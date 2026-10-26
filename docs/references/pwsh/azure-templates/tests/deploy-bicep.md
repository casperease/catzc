# pwsh/Azure.Templates/tests/Deploy-Bicep.Tests.ps1

The L0 tests of `Deploy-Bicep`: the devbox path, the hooks, dry runs and the do-not-run mode.

## Fixtures set up once

The static fixtures and the boundary mocks are set up once, not per test. The only per-test state is the hook marker files
(`pre-called.json` and `post-called.json`), cleared in `BeforeEach`. `main.json`, the parameters and `PrePost.psm1` never change, so
rebuilding them for every test was pure file-system-cmdlet tax, about five cmdlet calls at 20 ms each
([ADR-PWSH-PESTER-SYSTEMIOONHOTPATHS](../../../../drs/automation/pwsh/pester-testing.md#rule-adr-pwsh-pester-systemioonhotpaths)).
`[System.IO]` writes them in about 0.1 ms.

Only the marker files are cleared, so each test starts clean. The hooks write them, and several tests assert a marker is absent: `DryRun`
skips post-deploy, and `DoNotRun` runs no hooks.

## The PrePost fixture

The `PrePost.psm1` is a real per-template fixture. In the current model no default hook is loaded from assets, and `Deploy-Bicep` runs only
the hooks a template's own `PrePost.psm1` exports. The hooks record what they were called with to marker files, so the tests assert that the
template's own hooks ran, and with the right context.

## Mocks and caches

`$configCache` is reset once, not per test: the mocked config is the same fixture `azure.yml` for every test, so a per-test clear only
forced a needless cold re-parse of about 65 ms per test. Dropped once, it also removes any real-config entry left by a prior test file.

`Test-IsRunningInPipeline` is mocked to false because these tests exercise the devbox path. Without it the real function returns true under
CI (`$env:GITHUB_ACTIONS`), and `Deploy-Bicep` throws "requires -SubscriptionIdAssertIs in a pipeline".

`customer` is mocked alongside `azure` and `network` so template discovery validates the `sample-customer` fixture, its
`configuration/<customer>/` folders, against the fixture `customer.yml` and not the shipped one. Without it the file is not hermetic: it
passed only when `Build-Bicep.SampleCustomer` happened to share a worker and pre-populate the template-descriptor cache
([ADR-AUTO-TEST-SAFESEAMSWAPS](../../../../drs/automation/test-automation.md#rule-adr-auto-test-safeseamswaps),
[ADR-AUTO-TEST-SETUPONCE](../../../../drs/automation/test-automation.md#rule-adr-auto-test-setuponce)).

The fixture config and the template-discovery caches are warmed once under those mocks, so the cold derive is paid in setup and not by
whichever test happens to run first.
