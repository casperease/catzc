# pwsh/Base.ModuleSystem/tests/Test-ModuleDependency.Tests.ps1

The tests of `Test-ModuleDependency`, a quality gate
([ADR-AUTO-TEST-QUALITYGATE](../../../../drs/automation/test-automation.md#rule-adr-auto-test-qualitygate)). Each L0 case runs it with
`-PassThru` over mocked boundaries and reads the collected issues. The report goes to `$TestDrive`.
