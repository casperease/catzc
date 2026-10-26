# pwsh/Base.Objects/tests/types/ConsoleText.Tests.ps1

The L0 logic tests of `ConsoleText`, the shared console rendering behind every catzc type's `ToString()`.

## What it proves

An object held in pwsh reads as one line in `"$x"`, `[string]$x` and a table cell. The tests run through probe types compiled by `Add-Type`
against the loaded combined assembly, with neutral fixture names
([ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](../../../../../drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)).
