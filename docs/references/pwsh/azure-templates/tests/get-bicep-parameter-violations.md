# pwsh/Azure.Templates/tests/Get-BicepParameterViolations.Tests.ps1

The L0 logic tests of `Get-BicepParameterViolations`, with its per-entry and Key Vault reference checks.

## What is tested

Each violation kind is tested against a fixture `main.json` (`tests/assets/parameter-model/main.json`, with widget and gadget parameters,
[ADR-AUTO-TEST-DISTINCTFIXTURES](../../../../drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtures)) and a rendered
parameters file each test writes, plus a clean case. There is no az: `main.json` is written as a current build, so the model is read without
building. Discovery binds to the fixture templates (`sample`, with configs `alpha` and `beta`) and the output to this file's `$TestDrive`
through the seams
([ADR-PWSH-PESTER-ISOLATETHROUGHSEAMS](../../../../drs/automation/pwsh/pester-testing.md#rule-adr-pwsh-pester-isolatethroughseams)).

## The conforming set

`New-ConformingParameterSet` is a parameters file that satisfies the fixture model: every required parameter, and a Key Vault reference for
the secure one. Each test starts from it and changes one thing.
