# pwsh/Base.Execution/tests/types/ToolsConfig.Tests.ps1

The tests of `ToolsConfig`, in two contexts.

## Integrity

The integrity context reads the shipped `tools.yml` and guards real repository content
([ADR-AUTO-TEST-TWOMANDATORYTAGS](../../../../../drs/automation/test-automation.md#rule-adr-auto-test-twomandatorytags)).

## Logic

The logic context builds the constructor on an inline, synthetic config, independent of any shipped asset. The `python` rule keys on the
literal `python` tool (the pinned interpreter); every other tool is a fixture token
([ADR-AUTO-TEST-DISTINCTFIXTURES](../../../../../drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtures)).
