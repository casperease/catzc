# pwsh/Base.QualityGates/tests/Get-TestFileModule.Tests.ps1

The L0 logic test of `Get-TestFileModule`, with `Get-RepositoryRoot` and `Get-LanguageTestFolders` mocked. It proves that a run file maps to
its unit, which per-module protection needs. The fixtures use neutral names
([ADR-AUTO-TEST-DISTINCTFIXTURES](../../../../drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtures)).
