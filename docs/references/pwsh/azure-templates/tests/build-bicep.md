# pwsh/Azure.Templates/tests/Build-Bicep.Tests.ps1

<!-- cspell:ignore alweufxosmplst -->

The L0 tests of `Build-Bicep` against the `sample` fixture template, in a mocked-compiler block and a block for the real bicep binary.

## Setup

The boundary mocks and the config-cache reset run once, because the mocked config is identical for every test. Only the build output folder
is wiped per test, since the build tests write into it
([ADR-AUTO-TEST-SETUPONCE](../../../../drs/automation/test-automation.md#rule-adr-auto-test-setuponce),
[ADR-AUTO-TEST-SAFESEAMSWAPS](../../../../drs/automation/test-automation.md#rule-adr-auto-test-safeseamswaps)).

The file has its own output root through the seam: any other file building the `sample` fixture from a sibling worker can race the shared
`out/template/sample`
([ADR-AUTO-TEST-ONESCHEDULINGPOOL](../../../../drs/automation/test-automation.md#rule-adr-auto-test-oneschedulingpool), which removes the
sharing). One file runs in one worker, so the blocks of this file never overlap each other, and the guard block uses the same isolated root.

Discovery and the config caches are warmed once, because the cold re-derive the reset forces is one-time setup cost and not the first test's
duration. It had kept tipping that test over the L0 limit.

## The Bicep CLI guard

`Build-Bicep` resolves the bicep binary through `Resolve-ToolExecutable` and stops before any compile runs when it is missing or off the
`tools.yml` pin. The tests mock that boundary, so no version probe runs, and pin both failures by their `Install-Bicep` message.
