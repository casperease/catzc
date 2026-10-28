# pwsh/Azure.Templates/tests/Build-Bicep.SampleWithModule.Tests.ps1

<!-- cspell:ignore alweufxosmodst -->

The L0 tests of `Build-Bicep` against the `sample-with-module` fixture template, which carries a local reusable module.

## Setup

The boundary mocks and the config-cache reset run once, because the mocked config is identical for every test. Only the build output folder
is wiped per test, since the build tests write into it
([ADR-AUTO-TEST-SETUPONCE](../../../../drs/automation/test-automation.md#rule-adr-auto-test-setuponce),
[ADR-AUTO-TEST-SAFESEAMSWAPS](../../../../drs/automation/test-automation.md#rule-adr-auto-test-safeseamswaps)).

The build output is isolated to this file's throwaway `$TestDrive` through the output-root seam
([ADR-PWSH-PESTER-ISOLATETHROUGHSEAMS](../../../../drs/automation/pwsh/pester-testing.md#rule-adr-pwsh-pester-isolatethroughseams)), so it
never shares `out/template/<name>` with `Build-Bicep.L2` or the other sample files, the sharing the `serial` tag used to work around
([ADR-AUTO-TEST-ONESCHEDULINGPOOL](../../../../drs/automation/test-automation.md#rule-adr-auto-test-oneschedulingpool)). Mocking the seam
removes the sharing, so the file runs in parallel, and Pester cleans `$TestDrive`, so no manual output teardown is needed.

The discovery and config caches are warmed once, so the first `It` does not pay the cold `Get-BicepTemplate` derive inside its own timing
now that the file runs in the timed parallel phase.
