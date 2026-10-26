# pwsh/Base.Globs/tests/GlobSetTrigger-Coverage.Tests.ps1

The coverage test of the native-trigger projection over this repository's real tree
([FDR-GLOBS-NAMEDGLOBSETS](../../../../drs/flow/durable-sha-globs.md#rule-fdr-globs-namedglobsets)), run through its quality gate
`Test-GlobSetTriggerCoverage` ([ADR-AUTO-TEST-QUALITYGATE](../../../../drs/automation/test-automation.md#rule-adr-auto-test-qualitygate)).

## What it proves

Every member of a pipeline-bound set matches at least one Azure DevOps include pattern. An include-only trigger is therefore always a
superset of exact membership and can never under-trigger, which would miss a deploy. The in-pipeline `Test-GlobSetAffected` check supplies
the exactness on top.

GitHub is exact by construction: its ordered `!` negation paths are the scan program, evaluated by the same code as `GlobSet.Matches`, and
that is covered at L0.
