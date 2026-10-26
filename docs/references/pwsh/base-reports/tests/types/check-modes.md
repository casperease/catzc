# pwsh/Base.Reports/tests/types/CheckModes.Tests.ps1

The tests of `CheckModes`, the one parser of a check's mode setting, shared by every check config.

## What they pin

An omitted mode is the default declared once on `CheckMode`, and an unknown one gets the one error text. Every check config parses its mode
through this one function, so a second spelling or error text would show here first. The fixture values are neutral
([ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](../../../../../drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)).
