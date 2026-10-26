# pwsh/Base.QualityGates/private/Get-TestTimingViolation.ps1

Lists every passed test that exceeded its level's time limit, as report lines. It checks the aggregated per-test rows against the per-level
duration limits in timeouts.yml.

## help

### synopsis

Lists every passed test that exceeded its level's time limit, as report lines.

### description

Validates the aggregated per-test rows against the per-level duration limits (`tests.level_ms` in timeouts.yml, Get-TestTimeLimits; by
default L0 < 400ms, L1 < 2s, L2 < 30s, L3 < 120s). Only passed tests are checked — a failed test's duration is noise — and a row with no
resolved tier is skipped (the tag check already reported it). Test-Automation reports the lines and fails the run only under
-EnforceTimings.

### parameter `Rows`

The run's aggregated per-test rows.

### parameter `Limits`

The per-level duration limits (level tag -> milliseconds).
