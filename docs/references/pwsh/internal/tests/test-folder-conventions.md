# pwsh/.internal/tests/Test-FolderConventions.Tests.ps1

The tests of the folder and file conventions over the real tree, through `Test-FolderConventions` in `Catzc.Base.ModuleSystem`
([ADR-AUTO-TEST-QUALITYGATE](../../../../drs/automation/test-automation.md#rule-adr-auto-test-qualitygate)).

## What the block does

The check scans the tree once and lists every offender; the test block runs it at its tier and guards it against a silent no-op.
