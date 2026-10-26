# pwsh/Base.Drs/tests/Update-DrsCitation.Tests.ps1

The tests of `Update-DrsCitation`, which rewrites one file's ADR references through a code map and a rule map.

## Fixtures

Every test writes its own file into one shared fixture repository in `$TestDrive`: an ADR index of neutral widget and gizmo codes
([ADR-AUTO-TEST-DISTINCTFIXTURES](../../../../drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtures)) and the two fixture
maps under `tests/assets/update-drs-citation/`.

## The maps

In the fixture maps one ADR moves whole to another code and folder, one moves folder and keeps its code, and a folder maps to a new one. One
rule moves to a new ADR, and one rule collapses into a kept rule whose path only the index names.
