# pwsh/Azure.Templates/tests/Build-Bicep.SampleIndexed.Tests.ps1

<!-- cspell:ignore weufxosidxst -->

The L0 tests of `Build-Bicep` against the `sample-indexed` fixture template, whose slots are indexed.

## Setup

The boundary mocks and the config-cache reset run once, because the mocked config is identical for every test. Only the build output folder
is wiped per test, since the build tests write into it
([ADR-AUTO-TEST-SETUPONCE](../../../../drs/automation/test-automation.md#rule-adr-auto-test-setuponce),
[ADR-AUTO-TEST-SAFESEAMSWAPS](../../../../drs/automation/test-automation.md#rule-adr-auto-test-safeseamswaps)).

`Test-IsRunningInPipeline` is mocked to false, the devbox path. Under CI the real function returns true (`$env:GITHUB_ACTIONS`), and the
deployment-name test would then reach `Get-BicepDeploymentName`'s pipeline branch, which requires the ADO-only `$env:BUILD_BUILDID` and
throws on GitHub Actions.

The discovery and config caches are warmed once, so the first `It` does not pay the cold derive (template-tree enumeration and config load)
inside its own timing. Every test reads the same fixture template, and `BeforeEach` wipes only the build output, not the caches.

## A request with no slot

`alpha` with no `-Slot` resolves to config `alpha`, which this indexed-only template does not configure: it has `alpha-001` and `alpha-002`.
