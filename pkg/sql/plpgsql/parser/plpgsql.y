%{
package parser

import (
  "github.com/cockroachdb/cockroach/pkg/sql/scanner"
  "github.com/cockroachdb/cockroach/pkg/sql/sem/tree"
  "github.com/cockroachdb/cockroach/pkg/sql/sem/plpgsqltree"
  "github.com/cockroachdb/errors"
  "github.com/cockroachdb/redact"
)
%}

%{
func setErr(plpgsqllex plpgsqlLexer, err error) int {
    plpgsqllex.(*lexer).setErr(err)
    return 1
}

func unimplemented(plpgsqllex plpgsqlLexer, feature string) int {
    plpgsqllex.(*lexer).Unimplemented(feature)
    return 1
}

//functions to cast plpgsqlSymType/sqlSymUnion to other types.
var _ scanner.ScanSymType = &plpgsqlSymType{}

func (s *plpgsqlSymType) ID() int32 {
  return s.id
}

func (s *plpgsqlSymType) SetID(id int32) {
  s.id = id
}

func (s *plpgsqlSymType) Pos() int32 {
  return s.pos
}

func (s *plpgsqlSymType) SetPos(pos int32) {
  s.pos = pos
}

func (s *plpgsqlSymType) Str() string {
  return s.str
}

func (s *plpgsqlSymType) SetStr(str string) {
  s.str = str
}

func (s *plpgsqlSymType) UnionVal() interface{} {
  return s.union.val
}

func (s *plpgsqlSymType) SetUnionVal(val interface{}) {
  s.union.val = val
}

func (s *plpgsqlSymType) plpgsqlScanSymType() {}

type plpgsqlSymUnion struct {
    val interface{}
}

func (u *plpgsqlSymUnion) plpgsqlStmtBlock() *plpgsqltree.PLpgSQLStmtBlock {
    return u.val.(*plpgsqltree.PLpgSQLStmtBlock)
}

func (u *plpgsqlSymUnion) plpgsqlStmtCaseWhenArm() *plpgsqltree.PLpgSQLStmtCaseWhenArm {
    return u.val.(*plpgsqltree.PLpgSQLStmtCaseWhenArm)
}

func (u *plpgsqlSymUnion) plpgsqlStmtCaseWhenArms() []*plpgsqltree.PLpgSQLStmtCaseWhenArm {
    return u.val.([]*plpgsqltree.PLpgSQLStmtCaseWhenArm)
}

func (u *plpgsqlSymUnion) plpgsqlStatement() plpgsqltree.PLpgSQLStatement {
    return u.val.(plpgsqltree.PLpgSQLStatement)
}

func (u *plpgsqlSymUnion) plpgsqlStatements() []plpgsqltree.PLpgSQLStatement {
    return u.val.([]plpgsqltree.PLpgSQLStatement)
}

func (u *plpgsqlSymUnion) int32() int32 {
    return u.val.(int32)
}

func (u *plpgsqlSymUnion) uint32() uint32 {
    return u.val.(uint32)
}

func (u *plpgsqlSymUnion) bool() bool {
    return u.val.(bool)
}

func (u *plpgsqlSymUnion) numVal() *tree.NumVal {
    return u.val.(*tree.NumVal)
}

func (u *plpgsqlSymUnion) typ() tree.ResolvableTypeReference {
    return u.val.(tree.ResolvableTypeReference)
}

func (u *plpgsqlSymUnion) pLpgSQLGetDiagKind() plpgsqltree.PLpgSQLGetDiagKind {
    return u.val.(plpgsqltree.PLpgSQLGetDiagKind)
}

func (u *plpgsqlSymUnion) pLpgSQLStmtGetDiagItem() *plpgsqltree.PLpgSQLStmtGetDiagItem {
    return u.val.(*plpgsqltree.PLpgSQLStmtGetDiagItem)
}

func (u *plpgsqlSymUnion) pLpgSQLStmtGetDiagItemList() plpgsqltree.PLpgSQLStmtGetDiagItemList {
    return u.val.(plpgsqltree.PLpgSQLStmtGetDiagItemList)
}

func (u *plpgsqlSymUnion) pLpgSQLStmtIfElseIfArmList() []plpgsqltree.PLpgSQLStmtIfElseIfArm {
    return u.val.([]plpgsqltree.PLpgSQLStmtIfElseIfArm)
}

func (u *plpgsqlSymUnion) pLpgSQLStmtOpen() *plpgsqltree.PLpgSQLStmtOpen {
    return u.val.(*plpgsqltree.PLpgSQLStmtOpen)
}

func (u *plpgsqlSymUnion) plpgsqlExpr() plpgsqltree.PLpgSQLExpr {
    if u.val == nil {
      return nil
    }
    return u.val.(plpgsqltree.PLpgSQLExpr)
}

func (u *plpgsqlSymUnion) plpgsqlExprs() []plpgsqltree.PLpgSQLExpr {
    return u.val.([]plpgsqltree.PLpgSQLExpr)
}

func (u *plpgsqlSymUnion) plpgsqlDecl() *plpgsqltree.PLpgSQLDecl {
    return u.val.(*plpgsqltree.PLpgSQLDecl)
}

func (u *plpgsqlSymUnion) plpgsqlDecls() []plpgsqltree.PLpgSQLDecl {
    return u.val.([]plpgsqltree.PLpgSQLDecl)
}

func (u *plpgsqlSymUnion) plpgsqlOptionExpr() *plpgsqltree.PLpgSQLStmtRaiseOption {
    return u.val.(*plpgsqltree.PLpgSQLStmtRaiseOption)
}

func (u *plpgsqlSymUnion) plpgsqlOptionExprs() []plpgsqltree.PLpgSQLStmtRaiseOption {
    return u.val.([]plpgsqltree.PLpgSQLStmtRaiseOption)
}


func (u *plpgsqlSymUnion) plpgsqlException() *plpgsqltree.PLpgSQLException {
    return u.val.(*plpgsqltree.PLpgSQLException)
}

func (u *plpgsqlSymUnion) plpgsqlExceptions() []plpgsqltree.PLpgSQLException {
    return u.val.([]plpgsqltree.PLpgSQLException)
}

func (u *plpgsqlSymUnion) plpgsqlCondition() *plpgsqltree.PLpgSQLCondition {
    return u.val.(*plpgsqltree.PLpgSQLCondition)
}

func (u *plpgsqlSymUnion) plpgsqlConditions() []plpgsqltree.PLpgSQLCondition {
    return u.val.([]plpgsqltree.PLpgSQLCondition)
}

%}
/*
 * Basic non-keyword token types.  These are hard-wired into the core lexer.
 * They must be listed first so that their numeric codes do not depend on
 * the set of keywords.  Keep this list in sync with backend/parser/gram.y!
 *
 * Some of these are not directly referenced in this file, but they must be
 * here anyway.
 */
%token <str> IDENT UIDENT FCONST SCONST USCONST BCONST XCONST Op
%token <*tree.NumVal>	ICONST PARAM
%token <str> TYPECAST DOT_DOT COLON_EQUALS EQUALS_GREATER
%token <str> LESS_EQUALS GREATER_EQUALS NOT_EQUALS

/*
 * Other tokens recognized by plpgsql's lexer interface layer (pl_scanner.c).
 */
%token <str> LESS_LESS GREATER_GREATER

/*
 * Keyword tokens.  Some of these are reserved and some are not;
 * see pl_scanner.c for info.  Be sure unreserved keywords are listed
 * in the "unreserved_keyword" production below.
 */
%token <str>  ABSOLUTE
%token <str>  ALIAS
%token <str>  ALL
%token <str>  AND
%token <str>  ARRAY
%token <str>  ASSERT
%token <str>  BACKWARD
%token <str>  BEGIN
%token <str>  BY
%token <str>  CALL
%token <str>  CASE
%token <str>  CHAIN
%token <str>  CLOSE
%token <str>  COLLATE
%token <str>  COLUMN
%token <str>  COLUMN_NAME
%token <str>  COMMIT
%token <str>  CONSTANT
%token <str>  CONSTRAINT
%token <str>  CONSTRAINT_NAME
%token <str>  CONTINUE
%token <str>  CURRENT
%token <str>  CURSOR
%token <str>  DATATYPE
%token <str>  DEBUG
%token <str>  DECLARE
%token <str>  DEFAULT
%token <str>  DETAIL
%token <str>  DIAGNOSTICS
%token <str>  DO
%token <str>  DUMP
%token <str>  ELSE
%token <str>  ELSIF
%token <str>  END
%token <str>  END_CASE
%token <str>  END_IF
%token <str>  ERRCODE
%token <str>  ERROR
%token <str>  EXCEPTION
%token <str>  EXECUTE
%token <str>  EXIT
%token <str>  FETCH
%token <str>  FIRST
%token <str>  FOR
%token <str>  FOREACH
%token <str>  FORWARD
%token <str>  FROM
%token <str>  GET
%token <str>  HINT
%token <str>  IF
%token <str>  IMPORT
%token <str>  IN
%token <str>  INFO
%token <str>  INSERT
%token <str>  INTO
%token <str>  IS
%token <str>  LAST
%token <str>  LOG
%token <str>  LOOP
%token <str>  MERGE
%token <str>  MESSAGE
%token <str>  MESSAGE_TEXT
%token <str>  MOVE
%token <str>  NEXT
%token <str>  NO
%token <str>  NO_SCROLL
%token <str>  NOT
%token <str>  NOTICE
%token <str>  NULL
%token <str>  OPEN
%token <str>  OPTION
%token <str>  OR
%token <str>  PERFORM
%token <str>  PG_CONTEXT
%token <str>  PG_DATATYPE_NAME
%token <str>  PG_EXCEPTION_CONTEXT
%token <str>  PG_EXCEPTION_DETAIL
%token <str>  PG_EXCEPTION_HINT
%token <str>  PRINT_STRICT_PARAMS
%token <str>  PRIOR
%token <str>  QUERY
%token <str>  RAISE
%token <str>  RELATIVE
%token <str>  RETURN
%token <str>  RETURN_NEXT
%token <str>  RETURN_QUERY
%token <str>  RETURNED_SQLSTATE
%token <str>  REVERSE
%token <str>  ROLLBACK
%token <str>  ROW_COUNT
%token <str>  ROWTYPE
%token <str>  SCHEMA
%token <str>  SCHEMA_NAME
%token <str>  SCROLL
%token <str>  SLICE
%token <str>  SQLSTATE
%token <str>  STACKED
%token <str>  STRICT
%token <str>  TABLE
%token <str>  TABLE_NAME
%token <str>  THEN
%token <str>  TO
%token <str>  TYPE
%token <str>  USE_COLUMN
%token <str>  USE_VARIABLE
%token <str>  USING
%token <str>  VARIABLE_CONFLICT
%token <str>  WARNING
%token <str>  WHEN
%token <str>  WHILE


%union {
  id    int32
  pos   int32
  str   string
  union plpgsqlSymUnion
}

%type <str> decl_varname decl_defkey
%type <bool>	decl_const decl_notnull
%type <plpgsqltree.PLpgSQLExpr>	decl_defval decl_cursor_query
%type <tree.ResolvableTypeReference>	decl_datatype
%type <str>		decl_collate
%type <plpgsqltree.PLpgSQLDatum>	decl_cursor_args

%type <*plpgsqltree.PLpgSQLStmtOpen> open_stmt_processor
%type <str>	expr_until_semi expr_until_paren
%type <str>	expr_until_then expr_until_loop opt_expr_until_when
%type <plpgsqltree.PLpgSQLExpr>	opt_exitcond

%type <plpgsqltree.PLpgSQLScalarVar>		cursor_variable
%type <plpgsqltree.PLpgSQLDatum>	decl_cursor_arg
%type <forvariable>	for_variable
%type <plpgsqltree.PLpgSQLExpr>	return_variable
%type <*tree.NumVal>	foreach_slice
%type <plpgsqltree.PLpgSQLStatement>	for_control

%type <str> any_identifier opt_block_label opt_loop_label opt_label query_options
%type <str> opt_error_level option_type

%type <[]plpgsqltree.PLpgSQLStatement> proc_sect
%type <[]plpgsqltree.PLpgSQLStmtIfElseIfArm> stmt_elsifs
%type <[]plpgsqltree.PLpgSQLStatement> stmt_else loop_body // TODO is this a list of statement?
%type <plpgsqltree.PLpgSQLStatement>  pl_block
%type <plpgsqltree.PLpgSQLStatement>	proc_stmt
%type <plpgsqltree.PLpgSQLStatement>	stmt_assign stmt_if stmt_loop stmt_while stmt_exit stmt_continue
%type <plpgsqltree.PLpgSQLStatement>	stmt_return stmt_raise stmt_assert stmt_execsql
%type <plpgsqltree.PLpgSQLStatement>	stmt_dynexecute stmt_for stmt_perform stmt_call stmt_getdiag
%type <plpgsqltree.PLpgSQLStatement>	stmt_open stmt_fetch stmt_move stmt_close stmt_null
%type <plpgsqltree.PLpgSQLStatement>	stmt_commit stmt_rollback
%type <plpgsqltree.PLpgSQLStatement>	stmt_case stmt_foreach_a

%type <*plpgsqltree.PLpgSQLDecl> decl_stmt decl_statement
%type <[]plpgsqltree.PLpgSQLDecl> decl_sect opt_decl_stmts decl_stmts

%type <[]plpgsqltree.PLpgSQLException> exception_sect proc_exceptions
%type <*plpgsqltree.PLpgSQLException>	proc_exception
%type <[]plpgsqltree.PLpgSQLCondition> proc_conditions
%type <*plpgsqltree.PLpgSQLCondition> proc_condition

%type <*plpgsqltree.PLpgSQLStmtCaseWhenArm>	case_when
%type <[]*plpgsqltree.PLpgSQLStmtCaseWhenArm>	case_when_list
%type <[]plpgsqltree.PLpgSQLStatement> opt_case_else

%type <bool>	getdiag_area_opt
%type <plpgsqltree.PLpgSQLStmtGetDiagItemList>	getdiag_list // TODO don't know what this is
%type <*plpgsqltree.PLpgSQLStmtGetDiagItem> getdiag_list_item // TODO don't know what this is
%type <int32> getdiag_item

%type <*plpgsqltree.PLpgSQLStmtRaiseOption> option_expr
%type <[]plpgsqltree.PLpgSQLStmtRaiseOption> option_exprs opt_option_exprs
%type <plpgsqltree.PLpgSQLExpr> format_expr
%type <[]plpgsqltree.PLpgSQLExpr> opt_format_exprs format_exprs

%type <uint32>	opt_scrollable

%type <*plpgsqltree.PLpgSQLStmtFetch>	opt_fetch_direction

%type <*tree.NumVal>	opt_transaction_chain

%type <str>	unreserved_keyword
%%

pl_function:
  pl_block opt_semi
  {
    plpgsqllex.(*lexer).SetStmt($1.plpgsqlStatement())
  }

opt_semi:
| ';'
;

pl_block: opt_block_label decl_sect BEGIN proc_sect exception_sect END opt_label
  {
    $$.val = &plpgsqltree.PLpgSQLStmtBlock{
      Label: $1,
      Decls: $2.plpgsqlDecls(),
      Body: $4.plpgsqlStatements(),
      Exceptions: $5.plpgsqlExceptions(),
    }
  }
;

decl_sect: DECLARE opt_decl_stmts
  {
    $$.val = $2.plpgsqlDecls()
  }
| /* EMPTY */
  {
    // Use a nil slice to indicate DECLARE was not used.
    $$.val = []plpgsqltree.PLpgSQLDecl(nil)
  }
;

opt_decl_stmts: decl_stmts
  {
    $$.val = $1.plpgsqlDecls()
  }
| /* EMPTY */
  {
    $$.val = []plpgsqltree.PLpgSQLDecl{}
  }
;

decl_stmts: decl_stmts decl_stmt
  {
    decs := $1.plpgsqlDecls()
    dec := $2.plpgsqlDecl()
    if dec == nil {
      $$.val = decs
    } else {
      $$.val = append(decs, *dec)
    }
  }
| decl_stmt
  {
    dec := $1.plpgsqlDecl()
    if dec == nil {
      $$.val = []plpgsqltree.PLpgSQLDecl{}
    } else {
      $$.val = []plpgsqltree.PLpgSQLDecl{*dec}
    }
	}
;

decl_stmt	: decl_statement
  {
    $$.val = $1.plpgsqlDecl()
  }
| DECLARE
  {
    // This is to allow useless extra "DECLARE" keywords in the declare section.
    $$.val = (*plpgsqltree.PLpgSQLDecl)(nil)
  }
// TODO(chengxiong): turn this block on and throw useful error if user
// tries to put the block label just before BEGIN instead of before
// DECLARE.
//| LESS_LESS any_identifier GREATER_GREATER
//  {
//  }
;

decl_statement: decl_varname decl_const decl_datatype decl_collate decl_notnull decl_defval
  {
    $$.val = &plpgsqltree.PLpgSQLDecl{
      Var: plpgsqltree.PLpgSQLVariable($1),
      Constant: $2.bool(),
      Typ: $3.typ(),
      Collate: $4,
      NotNull: $5.bool(),
      Expr: $6.plpgsqlExpr(),
    }
  }
| decl_varname ALIAS FOR decl_aliasitem ';'
  {
    return unimplemented(plpgsqllex, "alias for")
  }
| decl_varname opt_scrollable CURSOR decl_cursor_args decl_is_for decl_cursor_query ';'
  {
    return unimplemented(plpgsqllex, "cursor")
  }
;

opt_scrollable:
  {
    return unimplemented(plpgsqllex, "cursor")
  }
| NO_SCROLL SCROLL
  {
    return unimplemented(plpgsqllex, "cursor")
  }
| SCROLL
  {
    return unimplemented(plpgsqllex, "cursor")
  }
;

decl_cursor_query:
  {
    plpgsqllex.(*lexer).ReadSqlExpressionStr(';')
  }
;

decl_cursor_args:
  {
  }
| '(' decl_cursor_arglist ')'
  {
  }
;

decl_cursor_arglist: decl_cursor_arg
  {
  }
| decl_cursor_arglist ',' decl_cursor_arg
  {
  }
;

decl_cursor_arg: decl_varname decl_datatype
  {
  }
;

decl_is_for:
  IS   /* Oracle */
| FOR  /* SQL standard */

decl_aliasitem: IDENT
  {
  }
| unreserved_keyword
  {
  }
;

decl_varname: IDENT
| unreserved_keyword
;

decl_const:
  {
    $$.val = false
  }
| CONSTANT
  {
    $$.val = true
  }
;

decl_datatype:
  {
    // Read until reaching one of the tokens that can follow a declaration
    // data type.
    sqlStr, _ := plpgsqllex.(*lexer).ReadSqlConstruct(
      ';', COLLATE, NOT, '=', COLON_EQUALS, DECLARE,
    )
    // TODO(drewk): need to ensure the syntax for the type is correct.
    typ, err := plpgsqllex.(*lexer).GetTypeFromValidSQLSyntax(sqlStr)
    if err != nil {
      setErr(plpgsqllex, err)
    }
    $$.val = typ
  }
;

decl_collate:
  {
    $$ = ""
  }
| COLLATE IDENT
  {
    $$ = $2
  }
| COLLATE unreserved_keyword
  {
    $$ = $2
  }
;

decl_notnull:
  {
    $$.val = false
  }
| NOT NULL
  {
    $$.val = true
  }
;

decl_defval: ';'
  {
    $$.val = (plpgsqltree.PLpgSQLExpr)(nil)
  }
| decl_defkey ';'
  {
    expr, err := plpgsqllex.(*lexer).ParseExpr($1)
    if err != nil {
      return setErr(plpgsqllex, err)
    }
    $$.val = expr
  }
;

decl_defkey: assign_operator
  {
    $$ = plpgsqllex.(*lexer).ReadSqlExpressionStr(';')
  }
| DEFAULT
  {
    $$ = plpgsqllex.(*lexer).ReadSqlExpressionStr(';')
  }
;

/*
 * Ada-based PL/SQL uses := for assignment and variable defaults, while
 * the SQL standard uses equals for these cases and for GET
 * DIAGNOSTICS, so we support both.  FOR and OPEN only support :=.
 */
assign_operator: '='
| COLON_EQUALS
;

proc_sect:
  {
    $$.val = []plpgsqltree.PLpgSQLStatement{}
  }
| proc_sect proc_stmt
  {
    stmts := $1.plpgsqlStatements()
    stmts = append(stmts, $2.plpgsqlStatement())
    $$.val = stmts
  }
;

proc_stmt:pl_block ';'
  {
    $$.val = $1.plpgsqlStmtBlock()
  }
| stmt_assign
  {
    $$.val = $1.plpgsqlStatement()
  }
| stmt_if
  {
    $$.val = $1.plpgsqlStatement()
  }
| stmt_case
  {
    $$.val = $1.plpgsqlStatement()
  }
| stmt_loop
  {
    $$.val = $1.plpgsqlStatement()
  }
| stmt_while
  { }
| stmt_for
  { }
| stmt_foreach_a
  { }
| stmt_exit
  {
    $$.val = $1.plpgsqlStatement()
  }
| stmt_continue
  {
    $$.val = $1.plpgsqlStatement()
  }
| stmt_return
  {
    $$.val = $1.plpgsqlStatement()
  }
| stmt_raise
  {
    $$.val = $1.plpgsqlStatement()
  }
| stmt_assert
  {
    $$.val = $1.plpgsqlStatement()
  }
| stmt_execsql
  {
    $$.val = $1.plpgsqlStatement()
  }
| stmt_dynexecute
  {
    $$.val = $1.plpgsqlStatement()
  }
| stmt_perform
  { }
| stmt_call
  {
    $$.val = $1.plpgsqlStatement()
  }
| stmt_getdiag
  { }
| stmt_open
  { }
| stmt_fetch
  { }
| stmt_move
  { }
| stmt_close
  {
    $$.val = $1.plpgsqlStatement()
  }
| stmt_null
  { }
| stmt_commit
  { }
| stmt_rollback
  { }
;

stmt_perform: PERFORM expr_until_semi ';'
  {
    return unimplemented(plpgsqllex, "perform")
  }
;

stmt_call: CALL call_cmd ';'
  {
    $$.val = &plpgsqltree.PLpgSQLStmtCall{IsCall: true}
  }
| DO call_cmd ';'
  {
    $$.val = &plpgsqltree.PLpgSQLStmtCall{IsCall: false}
  }
;

call_cmd:
  {
    plpgsqllex.(*lexer).ReadSqlExpressionStr(';')
  }
;

stmt_assign: IDENT assign_operator expr_until_semi ';'
  {
    expr, err := plpgsqllex.(*lexer).ParseExpr($3)
    if err != nil {
      return setErr(plpgsqllex, err)
    }
    $$.val = &plpgsqltree.PLpgSQLStmtAssign{
      Var: plpgsqltree.PLpgSQLVariable($1),
      Value: expr,
    }
  }
;

stmt_getdiag: GET getdiag_area_opt DIAGNOSTICS getdiag_list ';'
  {
  $$.val = &plpgsqltree.PLpgSQLStmtGetDiag{
    IsStacked: $2.bool(),
    DiagItems: $4.pLpgSQLStmtGetDiagItemList(),
  }
  // TODO(jane): Check information items are valid for area option.
  }
;

getdiag_area_opt:
  {
    $$.val = false
  }
| CURRENT
  {
    $$.val = false
  }
| STACKED
  {
    $$.val = true
  }
;

getdiag_list: getdiag_list ',' getdiag_list_item
  {
    $$.val = append($1.pLpgSQLStmtGetDiagItemList(), $3.pLpgSQLStmtGetDiagItem())
  }
| getdiag_list_item
  {
    $$.val = plpgsqltree.PLpgSQLStmtGetDiagItemList{$1.pLpgSQLStmtGetDiagItem()}
  }
;

getdiag_list_item: IDENT assign_operator getdiag_item
  {
    $$.val = &plpgsqltree.PLpgSQLStmtGetDiagItem{
      Kind : $3.pLpgSQLGetDiagKind(),
      TargetName: $1,
      // TODO(jane): set the target from $1.
    }
  }
;

getdiag_item: unreserved_keyword {
  switch $1 {
    case "row_count":
      $$.val = plpgsqltree.PlpgsqlGetdiagRowCount;
    case "pg_context":
      $$.val = plpgsqltree.PlpgsqlGetdiagContext;
    case "pg_exception_detail":
      $$.val = plpgsqltree.PlpgsqlGetdiagErrorDetail;
    case "pg_exception_hint":
      $$.val = plpgsqltree.PlpgsqlGetdiagErrorHint;
    case "pg_exception_context":
      $$.val = plpgsqltree.PlpgsqlGetdiagErrorContext;
    case "column_name":
      $$.val = plpgsqltree.PlpgsqlGetdiagColumnName;
    case "constraint_name":
      $$.val = plpgsqltree.PlpgsqlGetdiagConstraintName;
    case "pg_datatype_name":
      $$.val = plpgsqltree.PlpgsqlGetdiagDatatypeName;
    case "message_text":
      $$.val = plpgsqltree.PlpgsqlGetdiagMessageText;
    case "table_name":
      $$.val = plpgsqltree.PlpgsqlGetdiagTableName;
    case "schema_name":
      $$.val = plpgsqltree.PlpgsqlGetdiagSchemaName;
    case "returned_sqlstate":
      $$.val = plpgsqltree.PlpgsqlGetdiagReturnedSqlstate;
    default:
      // TODO(jane): Should this use an unimplemented error instead?
      setErr(plpgsqllex, errors.Newf("unrecognized GET DIAGNOSTICS item: %s", redact.Safe($1)))
  }
}
;

getdiag_target:
// TODO(jane): remove ident.
IDENT
  {
  }
;

stmt_if: IF expr_until_then THEN proc_sect stmt_elsifs stmt_else END_IF IF ';'
  {
    cond, err := plpgsqllex.(*lexer).ParseExpr($2)
    if err != nil {
      return setErr(plpgsqllex, err)
    }
    $$.val = &plpgsqltree.PLpgSQLStmtIf{
      Condition: cond,
      ThenBody: $4.plpgsqlStatements(),
      ElseIfList: $5.pLpgSQLStmtIfElseIfArmList(),
      ElseBody: $6.plpgsqlStatements(),
    }
  }
;

stmt_elsifs:
  {
    $$.val = []plpgsqltree.PLpgSQLStmtIfElseIfArm{};
  }
| stmt_elsifs ELSIF expr_until_then THEN proc_sect
  {
    cond, err := plpgsqllex.(*lexer).ParseExpr($3)
    if err != nil {
      return setErr(plpgsqllex, err)
    }
    newStmt := plpgsqltree.PLpgSQLStmtIfElseIfArm{
      Condition: cond,
      Stmts: $5.plpgsqlStatements(),
    }
    $$.val = append($1.pLpgSQLStmtIfElseIfArmList() , newStmt)
  }
;

stmt_else:
  {
    $$.val = []plpgsqltree.PLpgSQLStatement{};
  }
| ELSE proc_sect
  {
    $$.val = $2.plpgsqlStatements();
  }
;

stmt_case: CASE opt_expr_until_when case_when_list opt_case_else END_CASE CASE ';'
  {
    expr := &plpgsqltree.PLpgSQLStmtCase {
      TestExpr: $2,
      CaseWhenList: $3.plpgsqlStmtCaseWhenArms(),
    }
    if $4.val != nil {
       expr.HaveElse = true
       expr.ElseStmts = $4.plpgsqlStatements()
    }
    $$.val = expr
  }
;

opt_expr_until_when:
  {
    expr := ""
    tok := plpgsqllex.(*lexer).Peek()
    if tok.id != WHEN {
      expr = plpgsqllex.(*lexer).ReadSqlExpressionStr(WHEN)
    }
    $$ = expr
  }
;

case_when_list: case_when_list case_when
  {
    stmts := $1.plpgsqlStmtCaseWhenArms()
    stmts = append(stmts, $2.plpgsqlStmtCaseWhenArm())
    $$.val = stmts
  }
| case_when
  {
    stmts := []*plpgsqltree.PLpgSQLStmtCaseWhenArm{}
    stmts = append(stmts, $1.plpgsqlStmtCaseWhenArm())
    $$.val = stmts
  }
;

case_when: WHEN expr_until_then THEN proc_sect
  {
     expr := &plpgsqltree.PLpgSQLStmtCaseWhenArm{
       Expr: $2,
       Stmts: $4.plpgsqlStatements(),
     }
     $$.val = expr
  }
;

opt_case_else:
  {
    $$.val = nil
  }
| ELSE proc_sect
  {
    $$.val = $2.plpgsqlStatements()
  }
;

stmt_loop: opt_loop_label LOOP loop_body opt_label ';'
  {
    // TODO(drewk): does the second usage of the label actually
    // do anything?
    $$.val = &plpgsqltree.PLpgSQLStmtSimpleLoop{
      Label: $1,
      Body: $3.plpgsqlStatements(),
    }
  }
;

stmt_while: opt_loop_label WHILE expr_until_loop loop_body
  {
    return unimplemented(plpgsqllex, "while loop")
  }
;

stmt_for: opt_loop_label FOR for_control loop_body
  {
    return unimplemented(plpgsqllex, "for loop")
  }
;

for_control: for_variable IN
  // TODO need to parse the sql expression here.
  {
    return unimplemented(plpgsqllex, "for loop")
  }
;

/*
 * Processing the for_variable is tricky because we don't yet know if the
 * FOR is an integer FOR loop or a loop over query results.  In the former
 * case, the variable is just a name that we must instantiate as a loop
 * local variable, regardless of any other definition it might have.
 * Therefore, we always save the actual identifier into $$.name where it
 * can be used for that case.  We also save the outer-variable definition,
 * if any, because that's what we need for the loop-over-query case.  Note
 * that we must NOT apply check_assignable() or any other semantic check
 * until we know what's what.
 *
 * However, if we see a comma-separated list of names, we know that it
 * can't be an integer FOR loop and so it's OK to check the variables
 * immediately.  In particular, for T_WORD followed by comma, we should
 * complain that the name is not known rather than say it's a syntax error.
 * Note that the non-error result of this case sets *both* $$.scalar and
 * $$.row; see the for_control production.
 */
for_variable: any_identifier
  {
    return unimplemented(plpgsqllex, "for loop")
  }
;

stmt_foreach_a: opt_loop_label FOREACH for_variable foreach_slice IN ARRAY expr_until_loop loop_body
  {
    return unimplemented(plpgsqllex, "for each loop")
  }
;

foreach_slice:
  {
  }
| SLICE ICONST
  {
  }
;

stmt_exit: EXIT opt_label opt_exitcond
  {
    $$.val = &plpgsqltree.PLpgSQLStmtExit{
      Label: $2,
      Condition: $3.plpgsqlExpr(),
    }
  }
;

stmt_continue: CONTINUE opt_label opt_exitcond
  {
    $$.val = &plpgsqltree.PLpgSQLStmtContinue{
      Label: $2,
      Condition: $3.plpgsqlExpr(),
    }
  }
;

  // TODO handle variable names
  // 1. verify if the first token is a variable (this means that we need to track variable scope during parsing)
  // 2. if yes, check next token is ';'
  // 3. if no, expecting a sql expression "read_sql_expression"
  //    we can just read until a ';', then do the sql expression validation during compile time.

stmt_return: RETURN return_variable ';'
  {
    $$.val = &plpgsqltree.PLpgSQLStmtReturn{
      Expr: $2.plpgsqlExpr(),
    }
  }
| RETURN_NEXT NEXT return_variable ';'
  {
    return unimplemented(plpgsqllex, "return next")
  }
| RETURN_QUERY QUERY query_options ';'
 {
   return unimplemented (plpgsqllex, "return query")
 }
;


query_options:
  {
    _, terminator := plpgsqllex.(*lexer).ReadSqlExpressionStr2(EXECUTE, ';')
    if terminator == EXECUTE {
      return unimplemented (plpgsqllex, "return dynamic sql query")
    }
    plpgsqllex.(*lexer).ReadSqlExpressionStr(';')
  }
;


return_variable: expr_until_semi
  {
    expr, err := plpgsqllex.(*lexer).ParseExpr($1)
    if err != nil {
      return setErr(plpgsqllex, err)
    }
    $$.val = expr
  }
;

stmt_raise:
  RAISE ';'
  {
    return unimplemented(plpgsqllex, "empty RAISE statement")
  }
| RAISE opt_error_level SCONST opt_format_exprs opt_option_exprs ';'
  {
    $$.val = &plpgsqltree.PLpgSQLStmtRaise{
      LogLevel: $2,
      Message: $3,
      Params: $4.plpgsqlExprs(),
      Options: $5.plpgsqlOptionExprs(),
    }
  }
| RAISE opt_error_level IDENT opt_option_exprs ';'
  {
    $$.val = &plpgsqltree.PLpgSQLStmtRaise{
      LogLevel: $2,
      CodeName: $3,
      Options: $4.plpgsqlOptionExprs(),
    }
  }
| RAISE opt_error_level SQLSTATE SCONST opt_option_exprs ';'
  {
    $$.val = &plpgsqltree.PLpgSQLStmtRaise{
      LogLevel: $2,
      Code: $4,
      Options: $5.plpgsqlOptionExprs(),
    }
  }
| RAISE opt_error_level USING option_exprs ';'
  {
    $$.val = &plpgsqltree.PLpgSQLStmtRaise{
      LogLevel: $2,
      Options: $4.plpgsqlOptionExprs(),
    }
  }
;

opt_error_level:
  DEBUG
| LOG
| INFO
| NOTICE
| WARNING
| EXCEPTION
| /* EMPTY */
  {
    $$ = ""
  }
;

opt_option_exprs:
  USING option_exprs
  {
    $$.val = $2.plpgsqlOptionExprs()
  }
| /* EMPTY */
  {
    $$.val = []plpgsqltree.PLpgSQLStmtRaiseOption{}
  }
;

option_exprs:
  option_exprs ',' option_expr
  {
    option := $3.plpgsqlOptionExpr()
    $$.val = append($1.plpgsqlOptionExprs(), *option)
  }
| option_expr
  {
    option := $1.plpgsqlOptionExpr()
    $$.val = []plpgsqltree.PLpgSQLStmtRaiseOption{*option}
  }
;

option_expr:
  option_type assign_operator
  {
    // Read until reaching one of the tokens that can follow a raise option.
    sqlStr, _ := plpgsqllex.(*lexer).ReadSqlConstruct(',', ';')
    optionExpr, err := plpgsqllex.(*lexer).ParseExpr(sqlStr)
    if err != nil {
      return setErr(plpgsqllex, err)
    }
    $$.val = &plpgsqltree.PLpgSQLStmtRaiseOption{
      OptType: $1,
      Expr: optionExpr,
    }
  }
;

option_type:
  MESSAGE
| DETAIL
| HINT
| ERRCODE
| COLUMN
| CONSTRAINT
| DATATYPE
| TABLE
| SCHEMA
;

opt_format_exprs:
  format_exprs
  {
    $$.val = $1.plpgsqlExprs()
  }
 | /* EMPTY */
  {
    $$.val = []plpgsqltree.PLpgSQLExpr{}
  }
;

format_exprs:
  format_expr
  {
    $$.val = []plpgsqltree.PLpgSQLExpr{$1.plpgsqlExpr()}
  }
| format_exprs format_expr
  {
    $$.val = append($1.plpgsqlExprs(), $2.plpgsqlExpr())
  }
;

format_expr: ','
  {
    // Read until reaching a token that can follow a raise format parameter.
    sqlStr, _ := plpgsqllex.(*lexer).ReadSqlConstruct(',', ';', USING)
    param, err := plpgsqllex.(*lexer).ParseExpr(sqlStr)
    if err != nil {
      return setErr(plpgsqllex, err)
    }
    $$.val = param
  }
;

stmt_assert: ASSERT assert_cond ';'
  {
    $$.val = &plpgsqltree.PLpgSQLStmtAssert{}
  }
;

assert_cond:
  {
    _, terminator := plpgsqllex.(*lexer).ReadSqlExpressionStr2(',', ';')
    if terminator == ',' {
      plpgsqllex.(*lexer).ReadSqlExpressionStr(';')
    }
  }
;

loop_body: proc_sect END LOOP
  {
    $$.val = $1.plpgsqlStatements()
  }
;

stmt_execsql: stmt_execsql_start
  {
    stmt, err := plpgsqllex.(*lexer).MakeExecSqlStmt()
    if err != nil {
      return setErr(plpgsqllex, err)
    }
    $$.val = stmt
  }
;

stmt_execsql_start:
  IMPORT
| INSERT
| MERGE
| IDENT
;

stmt_dynexecute: EXECUTE
  {
    $$.val = plpgsqllex.(*lexer).MakeDynamicExecuteStmt()
  }
;

// TODO: change expr_until_semi to process_cursor_before_semi
stmt_open: OPEN IDENT open_stmt_processor ';'
  {
    openCursorStmt := $3.pLpgSQLStmtOpen()
    openCursorStmt.CursorName = $2
    $$.val = openCursorStmt
  }
;

stmt_fetch: FETCH opt_fetch_direction IDENT INTO
  {
    return unimplemented(plpgsqllex, "fetch")
  }
;

stmt_move: MOVE opt_fetch_direction IDENT ';'
  {
    return unimplemented(plpgsqllex, "move")
  }
;

opt_fetch_direction:
  {
      return unimplemented(plpgsqllex, "fetch direction")
  }

stmt_close: CLOSE cursor_variable ';'
  {
    $$.val = &plpgsqltree.PLpgSQLStmtClose{}
  }
;

stmt_null: NULL ';'
  {
  $$.val = &plpgsqltree.PLpgSQLStmtNull{};
  }
;

stmt_commit: COMMIT opt_transaction_chain ';'
  {
    return unimplemented(plpgsqllex, "commit")
  }
;

stmt_rollback: ROLLBACK opt_transaction_chain ';'
  {
    return unimplemented(plpgsqllex, "rollback")
  }
;

opt_transaction_chain:
AND CHAIN
  { }
| AND NO CHAIN
  { }
| /* EMPTY */
  { }

cursor_variable: IDENT
  {
    unimplemented(plpgsqllex, "cursor variable")
  }
;

exception_sect: /* EMPTY */
  {
    $$.val = []plpgsqltree.PLpgSQLException(nil)
  }
| EXCEPTION proc_exceptions
  {
    $$.val = $2.plpgsqlExceptions()
  }
;

proc_exceptions: proc_exceptions proc_exception
  {
    e := $2.plpgsqlException()
    $$.val = append($1.plpgsqlExceptions(), *e)
  }
| proc_exception
  {
    e := $1.plpgsqlException()
    $$.val = []plpgsqltree.PLpgSQLException{*e}
  }
;

proc_exception: WHEN proc_conditions THEN proc_sect
  {
    $$.val = &plpgsqltree.PLpgSQLException{
      Conditions: $2.plpgsqlConditions(),
      Action: $4.plpgsqlStatements(),
    }
  }
;

proc_conditions: proc_conditions OR proc_condition
  {
    c := $3.plpgsqlCondition()
    $$.val = append($1.plpgsqlConditions(), *c)
  }
| proc_condition
  {
    c := $1.plpgsqlCondition()
    $$.val = []plpgsqltree.PLpgSQLCondition{*c}
  }
;

proc_condition: any_identifier
  {
    $$.val = &plpgsqltree.PLpgSQLCondition{SqlErrName: $1}
  }
| SQLSTATE SCONST
  {
    $$.val = &plpgsqltree.PLpgSQLCondition{SqlErrState: $2}
  }
;

open_stmt_processor:
  {
	  $$.val = plpgsqllex.(*lexer).ProcessForOpenCursor(true)
  }

expr_until_semi:
  {
    $$ = plpgsqllex.(*lexer).ReadSqlExpressionStr(';')
  }
;

expr_until_then:
  {
    $$ = plpgsqllex.(*lexer).ReadSqlExpressionStr(THEN)
  }
;

expr_until_loop:
  {
    return unimplemented(plpgsqllex, "loop expr")
  }
;

expr_until_paren :
  {
    $$ = plpgsqllex.(*lexer).ReadSqlExpressionStr(')')
  }
;

opt_block_label	:
  {
    $$ = ""
  }
| LESS_LESS any_identifier GREATER_GREATER
  {
    $$ = $2
  }
;

opt_loop_label:
  {
    $$ = ""
  }
| LESS_LESS any_identifier GREATER_GREATER
  {
    $$ = $2
  }
;

opt_label:
  {
    $$ = ""
  }
| any_identifier
;

opt_exitcond: ';'
  { }
| WHEN expr_until_semi ';'
  {
    expr, err := plpgsqllex.(*lexer).ParseExpr($2)
    if err != nil {
      return setErr(plpgsqllex, err)
    }
    $$.val = expr
  }
;

/*
 * need to allow DATUM because scanner will have tried to resolve as variable
 */
any_identifier:
IDENT
| unreserved_keyword
;

unreserved_keyword:
  ABSOLUTE
| ALIAS
| AND
| ARRAY
| ASSERT
| BACKWARD
| CALL
| CHAIN
| CLOSE
| COLLATE
| COLUMN
| COLUMN_NAME
| COMMIT
| CONSTANT
| CONSTRAINT
| CONSTRAINT_NAME
| CONTINUE
| CURRENT
| CURSOR
| DATATYPE
| DEBUG
| DEFAULT
| DETAIL
| DIAGNOSTICS
| DO
| DUMP
| ELSIF
| ERRCODE
| ERROR
| EXCEPTION
| EXIT
| FETCH
| FIRST
| FORWARD
| GET
| HINT
| IMPORT
| INFO
| INSERT
| IS
| LAST
| LOG
| MERGE
| MESSAGE
| MESSAGE_TEXT
| MOVE
| NEXT
| NO
| NO_SCROLL
| NOTICE
| OPEN
| OPTION
| PERFORM
| PG_CONTEXT
| PG_DATATYPE_NAME
| PG_EXCEPTION_CONTEXT
| PG_EXCEPTION_DETAIL
| PG_EXCEPTION_HINT
| PRINT_STRICT_PARAMS
| PRIOR
| QUERY
| RAISE
| RELATIVE
| RETURN
| RETURN_NEXT
| RETURN_QUERY
| RETURNED_SQLSTATE
| REVERSE
| ROLLBACK
| ROW_COUNT
| ROWTYPE
| SCHEMA
| SCHEMA_NAME
| SCROLL
| SLICE
| SQLSTATE
| STACKED
| TABLE
| TABLE_NAME
| TYPE
| USE_COLUMN
| USE_VARIABLE
| VARIABLE_CONFLICT
| WARNING

reserved_keyword:
  ALL
| BEGIN
| BY
| CASE
| DECLARE
| ELSE
| END
| END_CASE
| END_IF
| EXECUTE
| FOR
| FOREACH
| FROM
| IF
| IN
| INTO
| LOOP
| NOT
| NULL
| OR
| STRICT
| THEN
| TO
| USING
| WHEN
| WHILE

%%
