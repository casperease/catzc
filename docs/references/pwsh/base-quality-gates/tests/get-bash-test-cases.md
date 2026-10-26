# pwsh/Base.QualityGates/tests/Get-BashTestCases.Tests.ps1

The tests of `Get-BashTestCases`, over fixture `.bats` files in `$TestDrive`. It reads the `@test` declarations of every `.bats` file, with
the file path bats reports as their package. Fixture names are neutral
([ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](../../../../drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)).
