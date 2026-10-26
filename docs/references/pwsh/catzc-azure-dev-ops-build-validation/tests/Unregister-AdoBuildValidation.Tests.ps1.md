# pwsh/Azure.DevOps.BuildValidation/tests/Unregister-AdoBuildValidation.Tests.ps1

The L0 tests of removal by the globset tie, the native path-filter projection. The command deletes the matched policy, does nothing when
the policy is already gone, because a policy already gone is no failure
([ADR-AUTO-IDEM-ALREADYDONEISFINE](../../../../drs/automation/idempotent-state-functions.md#rule-adr-auto-idem-alreadydoneisfine)), and
`-DryRun` returns the plan ([ADR-AUTO-DRYRUN](../../../../drs/automation/dry-run.md)).

## The REST mock

A mock body sees only the bound parameters, so it probes `Method` and defaults it the way the real command does.
