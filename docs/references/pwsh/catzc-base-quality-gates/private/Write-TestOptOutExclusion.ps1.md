# pwsh/Base.QualityGates/private/Write-TestOptOutExclusion.ps1

Prints and records the tests a test run's opt-out tag excluded. It is the visible half of the opt-out rule: the build run never drops a test
silently, so every test left out by the `source-only` tag is counted and listed.

## help

### synopsis

Prints and records the tests a test run's opt-out tag excluded — the visible half of the opt-out rule.

### description

The build run never drops a test silently: every test it leaves out by its opt-out tag ('source-only') is counted and listed on the console,
grouped by file (repository-relative), and written to excluded-tests.csv in the run directory (File, ExpandedPath, Level, Category) beside
tests.csv. Nothing to exclude still prints its one-line count, so a reader sees the exclusion was considered.

It rests on [ADR-AUTO-TEST-SOURCEONLYTAG](../../../../drs/automation/test-automation.md#rule-adr-auto-test-sourceonlytag).

### parameter `Tests`

The excluded test rows from Get-TestOptOutExclusion.

### parameter `Tag`

The opt-out tag(s), named in the message.

### parameter `RunDirectory`

The run directory excluded-tests.csv is written into.
