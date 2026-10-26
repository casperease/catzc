# pwsh/Base.Languages/tests/New-PythonProject.Tests.ps1

The logic tests of `New-PythonProject`, over a fixture repository in `$TestDrive` with its two declared configs mocked: `python.yml`
(`Get-Config`) and the python pin in `tools.yml` (`Get-ConfigValue`). The fixture names are neutral
([ADR-AUTO-TEST-DISTINCTFIXTURES](../../../../drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtures)).
