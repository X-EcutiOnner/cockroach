// Copyright 2017 The Cockroach Authors.
//
// Use of this software is governed by the CockroachDB Software License
// included in the /LICENSE file.

package types

import (
	"github.com/cockroachdb/cockroach/pkg/sql/oidext"
	"github.com/cockroachdb/errors"
	"github.com/lib/pq/oid"
)

// Convenience list of pre-constructed OID-related types.
var (
	// Oid is the type of a Postgres Object ID value.
	Oid = &T{InternalType: InternalType{
		Family: OidFamily, Oid: oid.T_oid, Locale: &emptyLocale}}

	// Regclass is the type of a Postgres regclass OID variant (T_regclass).
	RegClass = &T{InternalType: InternalType{
		Family: OidFamily, Oid: oid.T_regclass, Locale: &emptyLocale}}

	// RegNamespace is the type of a Postgres regnamespace OID variant
	// (T_regnamespace).
	RegNamespace = &T{InternalType: InternalType{
		Family: OidFamily, Oid: oid.T_regnamespace, Locale: &emptyLocale}}

	// RegProc is the type of a Postgres regproc OID variant (T_regproc).
	RegProc = &T{InternalType: InternalType{
		Family: OidFamily, Oid: oid.T_regproc, Locale: &emptyLocale}}

	// RegProcedure is the type of a Postgres regprocedure OID variant
	// (T_regprocedure).
	RegProcedure = &T{InternalType: InternalType{
		Family: OidFamily, Oid: oid.T_regprocedure, Locale: &emptyLocale}}

	// RegRole is the type of a Postgres regrole OID variant (T_regrole).
	RegRole = &T{InternalType: InternalType{
		Family: OidFamily, Oid: oid.T_regrole, Locale: &emptyLocale}}

	// RegType is the type of of a Postgres regtype OID variant (T_regtype).
	RegType = &T{InternalType: InternalType{
		Family: OidFamily, Oid: oid.T_regtype, Locale: &emptyLocale}}

	// OidVector is a type-alias for an array of Oid values, but with a different
	// OID (T_oidvector instead of T__oid). It is a special VECTOR type used by
	// Postgres in system tables. OidVectors are 0-indexed, unlike normal arrays.
	OidVector = &T{InternalType: InternalType{
		Family: ArrayFamily, Oid: oid.T_oidvector, ArrayContents: Oid, Locale: &emptyLocale}}
)

// OidToType maps Postgres object IDs to CockroachDB types.  We export the map
// instead of a method so that other packages can iterate over the map directly.
// Note that additional elements for the array Oid types are added in init().
var OidToType = map[oid.Oid]*T{
	oid.T_anyelement: AnyElement,
	oid.T_any:        Any,
	oid.T_bit:        typeBit,
	oid.T_bool:       Bool,
	oid.T_bpchar:     BPChar,
	oid.T_bytea:      Bytes,
	oid.T_char:       QChar,
	oid.T_date:       Date,
	oid.T_float4:     Float4,
	oid.T_float8:     Float,
	oid.T_int2:       Int2,
	oid.T_int2vector: Int2Vector,
	oid.T_int4:       Int4,
	oid.T_int8:       Int,
	oid.T_inet:       INet,
	oid.T_interval:   Interval,
	// NOTE(sql-exp): Uncomment the line below if we support the JSON type.
	// This would potentially require us to convert the type descriptors of
	// existing tables.
	// oid.T_json:      Json,
	oid.T_jsonb:        Jsonb,
	oid.T_name:         Name,
	oid.T_numeric:      Decimal,
	oid.T_oid:          Oid,
	oid.T_oidvector:    OidVector,
	oid.T_pg_lsn:       PGLSN,
	oid.T_record:       AnyTuple,
	oid.T_refcursor:    RefCursor,
	oid.T_regclass:     RegClass,
	oid.T_regnamespace: RegNamespace,
	oid.T_regproc:      RegProc,
	oid.T_regprocedure: RegProcedure,
	oid.T_regrole:      RegRole,
	oid.T_regtype:      RegType,
	oid.T_text:         String,
	oid.T_time:         Time,
	oid.T_timetz:       TimeTZ,
	oid.T_timestamp:    Timestamp,
	oid.T_timestamptz:  TimestampTZ,
	oid.T_trigger:      Trigger,
	oid.T_tsquery:      TSQuery,
	oid.T_tsvector:     TSVector,
	oid.T_unknown:      Unknown,
	oid.T_uuid:         Uuid,
	oid.T_varbit:       VarBit,
	oid.T_varchar:      VarChar,
	oid.T_void:         Void,

	oidext.T_geometry:  Geometry,
	oidext.T_geography: Geography,
	oidext.T_box2d:     Box2D,
	oidext.T_pgvector:  PGVector,
	oidext.T_jsonpath:  Jsonpath,
	oidext.T_citext:    CIText,
}

// oidToArrayOid maps scalar type Oids to their corresponding array type Oid.
var oidToArrayOid = map[oid.Oid]oid.Oid{
	oid.T_anyelement:   oid.T_anyarray,
	oid.T_bit:          oid.T__bit,
	oid.T_bool:         oid.T__bool,
	oid.T_bpchar:       oid.T__bpchar,
	oid.T_bytea:        oid.T__bytea,
	oid.T_char:         oid.T__char,
	oid.T_date:         oid.T__date,
	oid.T_float4:       oid.T__float4,
	oid.T_float8:       oid.T__float8,
	oid.T_inet:         oid.T__inet,
	oid.T_int2:         oid.T__int2,
	oid.T_int2vector:   oid.T__int2vector,
	oid.T_int4:         oid.T__int4,
	oid.T_int8:         oid.T__int8,
	oid.T_interval:     oid.T__interval,
	oid.T_jsonb:        oid.T__jsonb,
	oid.T_name:         oid.T__name,
	oid.T_numeric:      oid.T__numeric,
	oid.T_oid:          oid.T__oid,
	oid.T_oidvector:    oid.T__oidvector,
	oid.T_pg_lsn:       oid.T__pg_lsn,
	oid.T_record:       oid.T__record,
	oid.T_refcursor:    oid.T__refcursor,
	oid.T_regclass:     oid.T__regclass,
	oid.T_regnamespace: oid.T__regnamespace,
	oid.T_regproc:      oid.T__regproc,
	oid.T_regprocedure: oid.T__regprocedure,
	oid.T_regrole:      oid.T__regrole,
	oid.T_regtype:      oid.T__regtype,
	oid.T_text:         oid.T__text,
	oid.T_time:         oid.T__time,
	oid.T_timetz:       oid.T__timetz,
	oid.T_timestamp:    oid.T__timestamp,
	oid.T_timestamptz:  oid.T__timestamptz,
	oid.T_tsquery:      oid.T__tsquery,
	oid.T_tsvector:     oid.T__tsvector,
	oid.T_uuid:         oid.T__uuid,
	oid.T_varbit:       oid.T__varbit,
	oid.T_varchar:      oid.T__varchar,

	oidext.T_geometry:  oidext.T__geometry,
	oidext.T_geography: oidext.T__geography,
	oidext.T_box2d:     oidext.T__box2d,
	oidext.T_pgvector:  oidext.T__pgvector,
	oidext.T_jsonpath:  oidext.T__jsonpath,
	oidext.T_citext:    oidext.T__citext,
}

// familyToOid maps each type family to a default OID value that is used when
// another Oid is not present (e.g. when deserializing a type saved by a
// previous version of CRDB).
var familyToOid = map[Family]oid.Oid{
	BoolFamily:           oid.T_bool,
	IntFamily:            oid.T_int8,
	FloatFamily:          oid.T_float8,
	DecimalFamily:        oid.T_numeric,
	DateFamily:           oid.T_date,
	TimestampFamily:      oid.T_timestamp,
	IntervalFamily:       oid.T_interval,
	StringFamily:         oid.T_text,
	BytesFamily:          oid.T_bytea,
	TimestampTZFamily:    oid.T_timestamptz,
	CollatedStringFamily: oid.T_text,
	OidFamily:            oid.T_oid,
	PGLSNFamily:          oid.T_pg_lsn,
	RefCursorFamily:      oid.T_refcursor,
	UnknownFamily:        oid.T_unknown,
	UuidFamily:           oid.T_uuid,
	ArrayFamily:          oid.T_anyarray,
	INetFamily:           oid.T_inet,
	TimeFamily:           oid.T_time,
	TimeTZFamily:         oid.T_timetz,
	JsonFamily:           oid.T_jsonb,
	TSQueryFamily:        oid.T_tsquery,
	TSVectorFamily:       oid.T_tsvector,
	TupleFamily:          oid.T_record,
	BitFamily:            oid.T_bit,
	AnyFamily:            oid.T_anyelement,

	GeometryFamily:  oidext.T_geometry,
	GeographyFamily: oidext.T_geography,
	Box2DFamily:     oidext.T_box2d,
	PGVectorFamily:  oidext.T_pgvector,
	JsonpathFamily:  oidext.T_jsonpath,
}

// ArrayOids is a set of all oids which correspond to an array type.
var ArrayOids = map[oid.Oid]struct{}{}

func init() {
	for o, ao := range oidToArrayOid {
		ArrayOids[ao] = struct{}{}
		OidToType[ao] = MakeArray(OidToType[o])
	}
}

// CalcArrayOid returns the OID of the array type having elements of the given
// type.
func CalcArrayOid(elemTyp *T) oid.Oid {
	o := elemTyp.Oid()
	switch elemTyp.Family() {
	case ArrayFamily:
		// Postgres nested arrays return the OID of the nested array (i.e. the
		// OID doesn't change no matter how many levels of nesting there are),
		// except in the special-case of the vector types.
		switch o {
		case oid.T_int2vector, oid.T_oidvector:
			// Vector types have their own array OID types.
		default:
			return o
		}

	case UnknownFamily:
		// Postgres doesn't have an OID for an array of unknown values, since
		// it's not possible to create that in Postgres. But CRDB does allow that,
		// so return 0 for that case (since there's no T__unknown). This is what
		// previous versions of CRDB returned for this case.
		return unknownArrayOid

	case EnumFamily:
		return elemTyp.UserDefinedArrayOID()

	case TupleFamily:
		if elemTyp.UserDefined() {
			if elemTyp.TypeMeta.ImplicitRecordType {
				// We're currently not creating array types for implicitly-defined
				// per-table record types. So, we cheat a little, and return, as the OID
				// for an array of these things, the OID for a generic array of records.
				return oid.T__record
			}
			return elemTyp.UserDefinedArrayOID()
		}
	}

	// Map the OID of the array element type to the corresponding array OID.
	// This should always be possible for all other OIDs (checked in oid.go
	// init method).
	if o == oid.T_json {
		o = oid.T__json
	} else {
		o = oidToArrayOid[o]
	}
	if o == 0 {
		panic(errors.AssertionFailedf("oid %d couldn't be mapped to array oid", elemTyp.Oid()))
	}
	return o
}
