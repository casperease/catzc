# pwsh/Base.QualityGates/tests/ConvertTo-PesterRunTarget.Tests.ps1

The tests of `ConvertTo-PesterRunTarget`, over a fixture repository in `$TestDrive` with `Get-RepositoryRoot` and `Get-LanguageTestFolders`
mocked. A language test folder becomes a language bridge container, and everything else stays a Pester path. Fixture names are neutral
([ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](../../../../drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)).
