# pwsh/Base.Files/tests/Get-GitChangedPath.Tests.ps1

The L0 tests of `Get-GitChangedPath`: they parse the porcelain it reads, once against a mocked `git status` and once against one real
repository in `TestDrive:`.

## Fixtures

`git status` is the mocked boundary: the mock prints the `-z` porcelain, NUL-separated, so a NUL in a fixture is the separator, not data. The
fixtures use neutral names
([ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](../../../../drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)).
