# pwsh/Base.ConfigExtensions/tests/Test-ConfigValidators.Tests.ps1

The logic tests of `Test-ConfigValidators`: the gate must list, from each module's own scope, every validator that maps to no shipped
config.

## What it proves

The tests run the gate over a fixture code root in `$TestDrive` and two in-memory fixture modules whose validators are private, so only a
gate that reads each module's own scope lists them; the fixtures use neutral names
([ADR-AUTO-TEST-DISTINCTFIXTURES](../../../../drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtures)).

## Test titles

A test title avoids Pester's `<name>` template syntax: under the importer's strict mode an unmatched `<name>` token in an `It` title throws
when Pester expands the name, instead of expanding to empty.
