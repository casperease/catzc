# pwsh/Base.Languages/tests/ConvertFrom-BatsJunit.Tests.ps1

The logic tests of `ConvertFrom-BatsJunit`, over a canned bats JUnit report (`tests/assets/bats-widget.xml`, written in the shape bats 1.14
writes with `--report-formatter junit`). The fixture names are neutral
([ADR-AUTO-TEST-DISTINCTFIXTURES](../../../../drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtures)).
