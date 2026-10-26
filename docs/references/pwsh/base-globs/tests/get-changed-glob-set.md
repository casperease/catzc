# pwsh/Base.Globs/tests/Get-ChangedGlobSet.Tests.ps1

The tests of `Get-ChangedGlobSet`, the computed area-of-control of a diff
([FDR-GLOBS-NAMEDGLOBSETS](../../../../drs/flow/durable-sha-globs.md#rule-fdr-globs-namedglobsets)).

## What it proves

The declared sets whose scan program selects a changed path are reflected from git at real refs, instead of from a committed marker hash.

## Fixtures

The fixture globset names are neutral (widget, gadget, report), not the shipped set names, so the logic test owns its inputs
([ADR-AUTO-TEST-DISTINCTFIXTURES](../../../../drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtures)). The `report` set
overlaps `widget` on `src/**`. Both are loose filesets, the layer exempt from independence, which proves that multi-set matches come back in
registry order.
