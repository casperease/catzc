# pwsh/Base.Repository/tests/types/ParsedScripts.Tests.ps1

The L0 logic tests of the `ParsedScripts` type, the holder that parses each script file once.

## What it proves

One holder parses a file once, so every reader of the same script shares one syntax tree and one set of parse errors. The fixtures use
neutral names ([ADR-AUTO-TEST-DISTINCTFIXTURES](../../../../../drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtures)).
