// Copyright 2022 The Cockroach Authors.
//
// Use of this software is governed by the CockroachDB Software License
// included in the /LICENSE file.

package catpb

// AutoStatsCollectionStatus represents whether the auto stats collections
// enabled table setting is enabled, disabled, or not set.
type AutoStatsCollectionStatus int

// AutoPartialStatsCollectionStatus represents whether the auto partial stats
// collections enabled table setting is enabled, disabled or not set.
type AutoPartialStatsCollectionStatus int

// AutoFullStatsCollectionStatus represents whether the auto full stats
// collections enabled table setting is enabled, disabled or not set.
type AutoFullStatsCollectionStatus int

// The values for AutoStatsCollectionStatus.
const (
	AutoStatsCollectionNotSet AutoStatsCollectionStatus = iota
	AutoStatsCollectionEnabled
	AutoStatsCollectionDisabled
)

const (
	AutoPartialStatsCollectionNotSet AutoPartialStatsCollectionStatus = iota
	AutoPartialStatsCollectionEnabled
	AutoPartialStatsCollectionDisabled
)

const (
	AutoFullStatsCollectionNotSet AutoFullStatsCollectionStatus = iota
	AutoFullStatsCollectionEnabled
	AutoFullStatsCollectionDisabled
)

const (
	// AutoStatsEnabledSettingName is the name of the automatic stats collection
	// enabled cluster setting.
	AutoStatsEnabledSettingName = "sql.stats.automatic_collection.enabled"

	// AutoStatsEnabledTableSettingName is the name of the automatic stats
	// collection enabled table setting.
	AutoStatsEnabledTableSettingName = "sql_stats_automatic_collection_enabled"

	// AutoStatsMinStaleSettingName is the name of the automatic stats collection
	// min stale rows cluster setting.
	AutoStatsMinStaleSettingName = "sql.stats.automatic_collection.min_stale_rows"

	// UseStatsOnSystemTables is the name of the use statistics on system tables
	// cluster setting.
	UseStatsOnSystemTables = "sql.stats.system_tables.enabled"

	// AutoStatsOnSystemTables is the name of the autostats on system tables
	// cluster setting.
	AutoStatsOnSystemTables = "sql.stats.system_tables_autostats.enabled"

	// AutoStatsMinStaleTableSettingName is the name of the automatic stats collection
	// min stale rows table setting.
	AutoStatsMinStaleTableSettingName = "sql_stats_automatic_collection_min_stale_rows"

	// AutoStatsFractionStaleSettingName is the name of the automatic stats
	// collection fraction stale rows cluster setting.
	AutoStatsFractionStaleSettingName = "sql.stats.automatic_collection.fraction_stale_rows"

	// AutoStatsFractionStaleTableSettingName is the name of the automatic stats
	// collection fraction stale rows table setting.
	AutoStatsFractionStaleTableSettingName = "sql_stats_automatic_collection_fraction_stale_rows"

	// AutoPartialStatsEnabledSettingName is the name of the automatic partial
	// stats collection enabled cluster setting.
	AutoPartialStatsEnabledSettingName = "sql.stats.automatic_partial_collection.enabled"

	// AutoPartialStatsEnabledTableSettingName is the name of the automatic
	// partial stats collection enabled table setting.
	AutoPartialStatsEnabledTableSettingName = "sql_stats_automatic_partial_collection_enabled"

	// AutoPartialStatsMinStaleSettingName is the name of the automatic partial
	// stats collection min stale rows cluster setting.
	AutoPartialStatsMinStaleSettingName = "sql.stats.automatic_partial_collection.min_stale_rows"

	// AutoPartialStatsMinStaleTableSettingName is the name of the automatic
	// partial stats collection min stale rows table setting.
	AutoPartialStatsMinStaleTableSettingName = "sql_stats_automatic_partial_collection_min_stale_rows"

	// AutoPartialStatsFractionStaleSettingName is the name of the automatic
	// partial stats collection fraction stale rows cluster setting.
	AutoPartialStatsFractionStaleSettingName = "sql.stats.automatic_partial_collection.fraction_stale_rows"

	// AutoPartialStatsFractionStaleTableSettingName is the name of the automatic
	// partial stats collection fraction stale rows table setting.
	AutoPartialStatsFractionStaleTableSettingName = "sql_stats_automatic_partial_collection_fraction_stale_rows"

	// AutoFullStatsEnabledSettingName is the name of the automatic full
	// stats collection enabled cluster setting.
	AutoFullStatsEnabledSettingName = "sql.stats.automatic_full_collection.enabled"

	// AutoFullStatsEnabledTableSettingName is the name of the automatic
	// full stats collection enabled table setting.
	AutoFullStatsEnabledTableSettingName = "sql_stats_automatic_full_collection_enabled"

	// RBRUsingConstraintTableSettingName is the name of the REGIONAL BY ROW region
	// column inference setting.
	RBRUsingConstraintTableSettingName = "infer_rbr_region_col_using_constraint"
)

// AutoStatsCollectionEnabled indicates if automatic statistics collection is
// explicitly enabled or disabled.
func (as *AutoStatsSettings) AutoStatsCollectionEnabled() AutoStatsCollectionStatus {
	if as.Enabled == nil {
		return AutoStatsCollectionNotSet
	}
	if *as.Enabled {
		return AutoStatsCollectionEnabled
	}
	return AutoStatsCollectionDisabled
}

// AutoStatsMinStaleRows indicates the setting of
// sql_stats_automatic_collection_min_stale_rows in AutoStatsSettings. If ok is
// true, then the minStaleRows value is valid, otherwise this has not been set.
func (as *AutoStatsSettings) AutoStatsMinStaleRows() (minStaleRows int64, ok bool) {
	if as.MinStaleRows == nil {
		return 0, false
	}
	return *as.MinStaleRows, true
}

// AutoStatsFractionStaleRows indicates the setting of
// sql_stats_automatic_collection_fraction_stale_rows in AutoStatsSettings. If
// ok is true, then the fractionStaleRows value is valid, otherwise this has not
// been set.
func (as *AutoStatsSettings) AutoStatsFractionStaleRows() (fractionStaleRows float64, ok bool) {
	if as.FractionStaleRows == nil {
		return 0, false
	}
	return *as.FractionStaleRows, true
}

// NoAutoStatsSettingsOverrides is true if no auto stats related table
// settings are present in these AutoStatsSettings.
func (as *AutoStatsSettings) NoAutoStatsSettingsOverrides() bool {
	if as.Enabled != nil ||
		as.MinStaleRows != nil ||
		as.FractionStaleRows != nil ||
		as.PartialEnabled != nil ||
		as.FullEnabled != nil ||
		as.PartialMinStaleRows != nil ||
		as.PartialFractionStaleRows != nil {
		return false
	}
	return true
}

// TTLDefaultExpirationColumnName is the column name representing the expiration
// column for TTL.
const TTLDefaultExpirationColumnName = "crdb_internal_expiration"

// DefaultTTLExpirationExpr is default TTL expression when
// ttl_expiration_expression is not specified
var DefaultTTLExpirationExpr = Expression(TTLDefaultExpirationColumnName)

// AutoPartialStatsCollectionEnabled indicates if automatic partial statistics
// collection is explicitly enabled or disabled.
func (as *AutoStatsSettings) AutoPartialStatsCollectionEnabled() AutoPartialStatsCollectionStatus {
	if as.PartialEnabled == nil {
		return AutoPartialStatsCollectionNotSet
	}
	if *as.PartialEnabled {
		return AutoPartialStatsCollectionEnabled
	}
	return AutoPartialStatsCollectionDisabled
}

// AutoFullStatsCollectionEnabled indicates if automatic full statistics
// collection is explicitly enabled or disabled.
func (as *AutoStatsSettings) AutoFullStatsCollectionEnabled() AutoFullStatsCollectionStatus {
	if as.FullEnabled == nil {
		return AutoFullStatsCollectionNotSet
	}
	if *as.FullEnabled {
		return AutoFullStatsCollectionEnabled
	}
	return AutoFullStatsCollectionDisabled
}

// AutoPartialStatsMinStaleRows indicates the setting of
// sql_stats_automatic_partial_collection_min_stale_rows in
// AutoStatsSettings. If ok is true, then the minStaleRows value is
// valid, otherwise this has not been set.
func (as *AutoStatsSettings) AutoPartialStatsMinStaleRows() (minStaleRows int64, ok bool) {
	if as.PartialMinStaleRows == nil {
		return 0, false
	}
	return *as.PartialMinStaleRows, true
}

// AutoPartialStatsFractionStaleRows indicates the setting of
// sql_stats_automatic_partial_collection_fraction_stale_rows in
// AutoStatsSettings. If ok is true, then the fractionStaleRows value is valid,
// otherwise this has not been set.
func (as *AutoStatsSettings) AutoPartialStatsFractionStaleRows() (
	fractionStaleRows float64,
	ok bool,
) {
	if as.PartialFractionStaleRows == nil {
		return 0, false
	}
	return *as.PartialFractionStaleRows, true
}

// HasDurationExpr is a utility method to determine if ttl_expires_after was set
func (rowLevelTTL *RowLevelTTL) HasDurationExpr() bool {
	return rowLevelTTL.DurationExpr != ""
}

// HasExpirationExpr is a utility method to determine if ttl_expiration_expression was set
func (rowLevelTTL *RowLevelTTL) HasExpirationExpr() bool {
	return rowLevelTTL.ExpirationExpr != ""
}

// DeletionCronOrDefault returns the DeletionCron or the global default.
func (m *RowLevelTTL) DeletionCronOrDefault() string {
	if override := m.DeletionCron; override != "" {
		return override
	}
	return "@daily"
}

func (rowLevelTTL *RowLevelTTL) GetTTLExpr() Expression {
	if rowLevelTTL.HasExpirationExpr() {
		return rowLevelTTL.ExpirationExpr
	}
	return DefaultTTLExpirationExpr
}
