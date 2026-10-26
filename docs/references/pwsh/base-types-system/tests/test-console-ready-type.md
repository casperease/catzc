# pwsh/Base.TypesSystem/tests/Test-ConsoleReadyType.Tests.ps1

The L0 tests of `Test-ConsoleReadyType`: a shipped type renders as a readable line in pwsh when it overrides `ToString()`, or when it is a
kind never held as a value. The tests probe it with BCL types and `Add-Type` probes, and use neutral fixture names
([ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](../../../../drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)).
