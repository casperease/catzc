# pwsh/Azure.Templates/tests/Get-BicepDeploymentContext.Tests.ps1

The L0 tests of the deployment-context function: the devbox path, a pipeline path, a do-not-run template and the artifact paths.

## Setup once

The config and template boundary is mocked once for the whole block and the config cache is reset once. Every test reads the same fixture
config, and `Get-Config` keys its cache on the resolved fixture path, so the first call derives it cold, about 80 ms, and the rest hit the
warm cache. A per-test reset would force that cold re-derive on every test
([ADR-AUTO-TEST-SETUPONCE](../../../../drs/automation/test-automation.md#rule-adr-auto-test-setuponce),
[ADR-AUTO-TEST-SAFESEAMSWAPS](../../../../drs/automation/test-automation.md#rule-adr-auto-test-safeseamswaps)). Per test only the cheap
build folder is wiped, which a couple of tests depend on being clean.

The fixture config and the template-discovery caches are warmed once under the mocks, so the cold derive is paid in setup and not by
whichever test happens to run first.

The later blocks follow the same pattern. The pipeline block mutates neither the artifacts folder nor the environment variables, so its
fixture folder and pipeline-environment stand-ins are set up once and torn down once.

## Output root and mocks

The file has its own output root through the seam: any other file building the `sample` fixture from a sibling worker can race the shared
`out/template/sample`
([ADR-AUTO-TEST-ONESCHEDULINGPOOL](../../../../drs/automation/test-automation.md#rule-adr-auto-test-oneschedulingpool)). The root is kept
under the repository because the repo-relative artifact contract is asserted.

`Build-Bicep` is mocked to materialize stub artifacts without invoking az. It writes them with `[System.IO]`, about 0.1 ms against about 20
ms per call for the file cmdlets
([ADR-PWSH-PESTER-SYSTEMIOONHOTPATHS](../../../../drs/automation/pwsh/pester-testing.md#rule-adr-pwsh-pester-systemioonhotpaths)).

The deploy target is the az session's subscription, so a whole-boundary session mock stands in for the service connection and
`az account set`
([ADR-PWSH-PESTER-MOCKMODULEBOUNDARIES](../../../../drs/automation/pwsh/pester-testing.md#rule-adr-pwsh-pester-mockmoduleboundaries)).

`Get-BicepTemplate` is mocked to stand in for a template whose `options.yml` declared `deployment_mode: DoNotRun`, keeping the rest of the
real `sample` descriptor so full resolution still works when overridden.
