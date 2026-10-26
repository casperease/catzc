# pwsh/Base.QualityGates/tests/Get-GoTestCases.Tests.ps1

<!-- cspell:ignore Testlowercase -->

The tests of `Get-GoTestCases` over a fixture Go test folder in `$TestDrive`, with the go config mocked to its defaults. The Go tests are
read from the `*_test.go` source, never by running go. Fixture names are neutral
([ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](../../../../drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)).
