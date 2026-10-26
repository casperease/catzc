# pwsh/Azure.Templates/tests/Build-Bicep.SampleWithPrepost.Tests.ps1

The L0 tests of `Build-Bicep` against the `sample-with-prepost` fixture template, whose `PrePost.psm1` hook injects values.

## Expected values

The merge seam injects the vnet ranges from the network fixture, so the tests resolve the expected per-environment values straight from the
asset and track it. The hook injects an ARM Key Vault reference, not the value, because the config does not carry it. That is the production
pattern for keeping deploy-time secrets out of the repository, proven here on a fixture so no test binds to a real template's secret name.

## One build

The path-keyed session caches are warmed once, not per test
([ADR-AUTO-TEST-SETUPONCE](../../../../drs/automation/test-automation.md#rule-adr-auto-test-setuponce)).

One build of all environments is the single observation every assertion is a facet of
([ADR-AUTO-TEST-ONEIMPORTPERCASE](../../../../drs/automation/test-automation.md#rule-adr-auto-test-oneimportpercase)), not a rebuild per
test. Building all environments yields `alpha` and `beta`, so every per-environment range, vnet and reference check reads the captured
output instead of re-invoking `Build-Bicep`. Under the sharded, greedy run a `Build-Bicep` call (the PrePost import plus file I/O) costs
five to six times its warm solo time from CPU and I/O contention, and collapsing six builds to one keeps every `It` within the L0 time
budget.
