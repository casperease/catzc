# pwsh/Base.Repository/tests/types/SyntaxSearch.Tests.ps1

The L0 logic tests of the `SyntaxSearch` type, the compiled searches over a parsed syntax tree.

## What it proves

Each compiled search returns exactly what a PowerShell predicate over `FindAll` returns, so swapping one for the other changes nothing. The
fixtures use neutral names
([ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](../../../../../drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)).
