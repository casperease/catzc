# pwsh/Azure.Templates/tests/Get-BicepParameterModel.Tests.ps1

The L0 logic tests of `Get-BicepParameterModel` and the `BicepParameterModel` and `BicepParameter` types it returns.

## What is tested

The tests cover the model parsed from a fixture `main.json` (`tests/assets/parameter-model/main.json`, with widget and gadget parameters,
[ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](../../../../drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)), and
the build-when-not-current decision. There is no az: the fixture stands in for the compiled `main.json`, and `Build-Bicep`, the one az
touch, is mocked. Discovery binds to the fixture templates and the output to this file's `$TestDrive` through the seams
([ADR-PWSH-PESTER-ISOLATETHROUGHSEAMS](../../../../drs/automation/pwsh/pester-testing.md#rule-adr-pwsh-pester-isolatethroughseams)).

## Fixture builds

`Write-FixtureBuild` writes the fixture, it does not copy it. A copy keeps the source's timestamp, and the model reads a build as current
only when `main.json` is at least as new as the template's inputs.
