# pwsh/Base.Languages/tests/ConvertFrom-PytestJunit.Tests.ps1

The logic tests of `ConvertFrom-PytestJunit`, over a canned pytest JUnit report in `tests/assets`: one result per top-level test function,
parametrised cases folded in. The fixture names are neutral
([ADR-AUTO-TEST-DISTINCTFIXTURES](../../../../drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtures)).
