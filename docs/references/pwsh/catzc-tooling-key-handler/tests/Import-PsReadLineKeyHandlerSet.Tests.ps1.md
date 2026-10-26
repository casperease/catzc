# pwsh/Tooling.KeyHandler/tests/Import-PsReadLineKeyHandlerSet.Tests.ps1

The L0 tests of `Import-PsReadLineKeyHandlerSet`. `Get-Config` is mocked to real config types built from fixture data, so a binding is
planned as supported exactly when the allow-list names its function, and `-DryRun` applies nothing.

## What is not tested here

The shipped configs' load is the quality gate `Test-ShippedConfigs`, and a binding's non-empty key and function is a `KeyHandlerBinding`
construction rule, so neither is repeated. The fixtures use neutral names
([ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](../../../../drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)).
