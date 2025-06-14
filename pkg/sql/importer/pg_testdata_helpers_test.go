// Copyright 2018 The Cockroach Authors.
//
// Use of this software is governed by the CockroachDB Software License
// included in the /LICENSE file.

package importer

import (
	gosql "database/sql"
	"fmt"
	"math/rand"
	"os"
	"os/exec"
	"path/filepath"
	"strings"
	"testing"
	"unicode/utf8"

	"github.com/cockroachdb/cockroach/pkg/roachpb"
	"github.com/cockroachdb/cockroach/pkg/testutils/datapathutils"
	"github.com/cockroachdb/cockroach/pkg/util/envutil"
	_ "github.com/lib/pq"
)

var rewritePostgresTestData = envutil.EnvOrDefaultBool("COCKROACH_REWRITE_POSTGRES_TESTDATA", false)

var simplePostgresTestRows = func() []simpleTestRow {
	badChars := []rune{'a', ';', '\n', ',', '"', '\\', '\r', '<', '\t', '✅', 'π', rune(10), rune(2425), rune(5183), utf8.RuneError}
	r := rand.New(rand.NewSource(1))
	testRows := []simpleTestRow{
		{i: 0, s: `str`},
		{i: 1, s: ``},
		{i: 2, s: ` `},
		{i: 3, s: `,`},
		{i: 4, s: "\n"},
		{i: 5, s: `\n`},
		{i: 6, s: "\r\n"},
		{i: 7, s: "\r"},
		{i: 9, s: `"`},

		{i: 10, s: injectNull},
		{i: 11, s: `\N`},
		{i: 12, s: `NULL`},

		// Unicode
		{i: 13, s: `¢`},
		{i: 14, s: ` ¢ `},
		{i: 15, s: `✅`},
		{i: 16, s: `","\n,™¢`},
		{i: 19, s: `✅¢©ƒƒƒƒåß∂√œ∫∑∆πœ∑˚¬≤µµç∫ø∆œ∑∆¬œ∫œ∑´´†¥¨ˆˆπ‘“æ…¬…¬˚ß∆å˚˙ƒ∆©˙©∂˙≥≤Ω˜˜µ√∫∫Ω¥∑`},
		{i: 20, s: `a quote " or two quotes "" and a quote-comma ", , and then a quote and newline "` + "\n"},
		{i: 21, s: `"a slash \, a double slash \\, a slash+quote \",  \` + "\n"},
	}

	for i := 0; i < 10; i++ {
		buf := make([]byte, 200)
		r.Seed(int64(i))
		r.Read(buf)
		testRows = append(testRows, simpleTestRow{i: i + 100, s: randStr(r, badChars, 1000), b: buf})
	}
	return testRows
}()

type pgCopyCfg struct {
	name     string
	filename string
	opts     roachpb.PgCopyOptions
}

func getPgCopyTestdata(t *testing.T) ([]simpleTestRow, []pgCopyCfg) {
	configs := []pgCopyCfg{
		{
			name: "default",
			opts: roachpb.PgCopyOptions{
				Delimiter: '\t',
				Null:      `\N`,
			},
		},
		{
			name: "comma-null-header",
			opts: roachpb.PgCopyOptions{
				Delimiter: ',',
				Null:      "null",
			},
		},
	}

	for i := range configs {
		configs[i].filename = datapathutils.TestDataPath(t, `pgcopy`, configs[i].name, `test.txt`)
	}

	if rewritePostgresTestData {
		genSimplePostgresTestdata(t, func() {
			if err := os.RemoveAll(datapathutils.TestDataPath(t, `pgcopy`)); err != nil {
				t.Fatal(err)
			}
			for _, cfg := range configs {
				dest := filepath.Dir(cfg.filename)
				if err := os.MkdirAll(dest, 0777); err != nil {
					t.Fatal(err)
				}

				var sb strings.Builder
				sb.WriteString(`COPY simple TO STDOUT WITH (FORMAT 'text'`)
				if cfg.opts.Delimiter != copyDefaultDelimiter {
					fmt.Fprintf(&sb, `, DELIMITER %q`, cfg.opts.Delimiter)
				}
				if cfg.opts.Null != copyDefaultNull {
					fmt.Fprintf(&sb, `, NULL "%s"`, cfg.opts.Null)
				}
				sb.WriteString(`)`)
				flags := []string{`-U`, `postgres`, `-h`, `127.0.0.1`, `test`, `-c`, sb.String()}
				if res, err := exec.Command(
					`psql`, flags...,
				).CombinedOutput(); err != nil {
					t.Fatal(err, string(res))
				} else if err := os.WriteFile(cfg.filename, res, 0666); err != nil {
					t.Fatal(err)
				}
			}
		})
	}

	return simplePostgresTestRows, configs
}

func genSimplePostgresTestdata(t *testing.T, dump func()) {
	defer genPostgresTestdata(t,
		"simple",
		`i INT PRIMARY KEY, s text, b bytea`,
		func(db *gosql.DB) {
			// Postgres doesn't support creating non-unique indexes in CREATE TABLE;
			// do it afterward.
			if _, err := db.Exec(`
				CREATE UNIQUE INDEX ON simple (b, s);
				CREATE INDEX ON simple (s);
			`); err != nil {
				t.Fatal(err)
			}
			for _, tc := range simplePostgresTestRows {
				s := &tc.s
				if *s == injectNull {
					s = nil
				}
				if _, err := db.Exec(
					`INSERT INTO simple VALUES ($1, $2, NULLIF($3, ''::bytea))`, tc.i, s, tc.b,
				); err != nil {
					t.Fatal(err)
				}
			}
		},
	)()
	dump()
}

// genPostgresTestdata connects to the a local postgres, creates the passed
// table and calls the passed `load` func to populate it and returns a
// cleanup func.
func genPostgresTestdata(t *testing.T, name, schema string, load func(*gosql.DB)) func() {
	db, err := gosql.Open("postgres", "postgres://postgres@localhost/test?sslmode=disable")
	if err != nil {
		t.Fatal(err)
	}
	defer db.Close()

	if _, err := db.Exec(
		fmt.Sprintf(`DROP TABLE IF EXISTS %s`, name),
	); err != nil {
		t.Fatal(err)
	}
	if _, err := db.Exec(
		fmt.Sprintf(`CREATE TABLE %s (%s)`, name, schema),
	); err != nil {
		t.Fatal(err)
	}
	load(db)
	return func() {
		db, err := gosql.Open("postgres", "postgres://postgres@localhost/test?sslmode=disable")
		if err != nil {
			t.Fatal(err)
		}
		defer db.Close()
		if _, err := db.Exec(
			fmt.Sprintf(`DROP TABLE IF EXISTS %s`, name),
		); err != nil {
			t.Fatal(err)
		}
	}
}
