# pwsh/Azure.Templates/tests/Deploy-Bicep.SampleSubscription.Tests.ps1

The L0 tests of `Deploy-Bicep` against the `sample-subscription` fixture template.

## Mocks

The deploy target is the az session's subscription, so `Get-AzCliSessionSubscription` is a whole-boundary mock
([ADR-PWSH-PESTER-MOCKMODULEBOUNDARIES](../../../../drs/automation/pwsh/pester-testing.md#rule-adr-pwsh-pester-mockmoduleboundaries)).

`Test-IsRunningInPipeline` is mocked to false, the devbox path. Without it the real function returns true under CI (`$env:GITHUB_ACTIONS`),
and `Deploy-Bicep` throws "requires -SubscriptionIdAssertIs in a pipeline".

The path-keyed session caches are warmed once per block, not per test
([ADR-AUTO-TEST-SETUPONCE](../../../../drs/automation/test-automation.md#rule-adr-auto-test-setuponce)).
