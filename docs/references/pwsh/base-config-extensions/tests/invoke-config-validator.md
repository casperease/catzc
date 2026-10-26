# pwsh/Base.ConfigExtensions/tests/Invoke-ConfigValidator.Tests.ps1

The logic tests of `Invoke-ConfigValidator`: it must find a module's private validator by convention and run it in that module's own scope.

## What it proves

The tests build in-memory fixture modules whose validators are private, so a validator found and run from the caller's scope would fail; the
fixtures use neutral names
([ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](../../../../drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)).
