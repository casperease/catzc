# pwsh/Base.Writers/tests/types/Ansi.Tests.ps1

The L0 logic tests of the `Ansi` type, the single `ConsoleColor` to ANSI SGR map
([ADR-AUTO-CONSOLE-SPARINGCOLOUR](../../../../../drs/automation/console-output-matters.md#rule-adr-auto-console-sparingcolour)).

## What it proves

The escape codes that `Write-InformationColored` and `RainbowColor` both resolve through are asserted in one place, so the two can never
disagree.
