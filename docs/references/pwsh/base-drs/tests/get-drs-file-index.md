# pwsh/Base.Drs/tests/Get-DrsFileIndex.Tests.ps1

The tests of `Get-DrsFileIndex`: every `docs/drs/**/*.md` keyed by `<domain folder>/<slug>`, and each rule set mapped to its one file.

## Fixtures

A fixture tree in `$TestDrive` and a fixture registry, with neutral names
([ADR-AUTO-TEST-DISTINCTFIXTURES](../../../../drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtures)).
