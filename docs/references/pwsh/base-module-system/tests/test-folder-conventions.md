# pwsh/Base.ModuleSystem/tests/Test-FolderConventions.Tests.ps1

The tests of the `Test-FolderConventions` gate, over fixture module trees in `$TestDrive`. The repository root is mocked, so each test
builds the folders it needs and pins one convention. The fixture names are neutral
([ADR-AUTO-TEST-DISTINCTFIXTURES](../../../../drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtures)).
