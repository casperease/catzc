# pwsh/Tooling.KeyHandler/tests/Select-SupportedKeyHandler.Tests.ps1

The L0 tests of `Select-SupportedKeyHandler`, the pure classification of captured bindings against the allow-list.

## Fixtures

The function names are neutral (widget, gadget), because the command is pure classification logic and a logic fixture must not borrow real
PSReadLine function names
([ADR-AUTO-TEST-DISTINCTFIXTURES](../../../../drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtures)).
