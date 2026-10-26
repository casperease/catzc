# pwsh/Base.QualityGates/tests/Get-LanguageTestFolders.Tests.ps1

The tests of `Get-LanguageTestFolders` over a fixture repository in `$TestDrive`, with `Get-RepositoryRoot` and the go config mocked. The
fixture holds catzc modules under `pwsh/`, Go test folders under the `go/` root, Python test folders under `python/` and Bash test folders
under `bash/`. Fixture names are neutral
([ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](../../../../drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)).

## What is not a test folder

A dot-prefixed folder, a folder left with only generated files, a Python folder with no `test_*.py` file, and a Bash folder with no `.bats`
file.
