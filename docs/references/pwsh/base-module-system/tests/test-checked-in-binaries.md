# pwsh/Base.ModuleSystem/tests/Test-CheckedInBinaries.Tests.ps1

The tests of the `Test-CheckedInBinaries` gate, in two parts.

## Logic tests

They run over fixture files in `$TestDrive` with the git CLI mocked: `ls-files --eol` and `check-attr binary` answer from each test's
listing, so each test pins one storage rule. The fixture names are neutral
([ADR-AUTO-TEST-DISTINCTFIXTURES](../../../../drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtures)).

## The real repository

The L2 test runs the gate over the real repository
([ADR-AUTO-TEST-QUALITYGATE](../../../../drs/automation/test-automation.md#rule-adr-auto-test-qualitygate)). It drives the real git CLI, so
it skips itself when git is absent or the run is not inside a work tree, for example from an exported tarball, as the test-automation
tiering requires.
