# pwsh/Azure.DevOps.BuildValidation/tests/Register-AdoBuildValidation.Tests.ps1

The L0 tests of the write side: the idempotent create-or-update of one globset's build-validation policy, with everything defaulted from
`build-validation.yml`, `globs.yml` and `ado.yml`. `-DryRun` returns the plan
([ADR-AUTO-DRYRUN](../../../../drs/automation/dry-run.md)).

## The REST mock

A mock body sees only the bound parameters, so it probes `Method` and defaults it the way the real command does.
