# pwsh/Base.Objects/tests/types/DictionaryRecord.Tests.ps1

The L0 logic tests of `DictionaryRecord`, the shared base of the YAML-mirror records.

## What it proves

The base gives a derived record a dictionary view over its own data properties, and protected extraction helpers (`Req`, `OptStr`, `StrArr`,
`Flag`) for a derived constructor. The tests run through a probe record compiled by `Add-Type` against the loaded combined assembly, which
also shows that a type compiled later can derive from the base. The fixtures use neutral names
([ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](../../../../../drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)).

## An unset property

The probe's `Gadget` property is never assigned by the first constructor, so it is genuinely null. Passing `$null` from PowerShell would
coerce to `''`, the `[string]` null-to-empty pitfall, so that constructor leaves the property unset.
