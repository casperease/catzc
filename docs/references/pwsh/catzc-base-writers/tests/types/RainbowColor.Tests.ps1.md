# pwsh/Base.Writers/tests/types/RainbowColor.Tests.ps1

The L0 logic tests of the `RainbowColor` type, the `<base>-rainbow` colour profile
([ADR-AUTO-CONSOLE-SPARINGCOLOUR](../../../../../drs/automation/console-output-matters.md#rule-adr-auto-console-sparingcolour)).

## What it proves

Char 0 is the anchor, the walk steps a chromatic-only ring that stays legible on a dark ground, and the profile side-grades to its base
`ConsoleColor`.
