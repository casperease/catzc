# automation/pwsh/Catzc.Azure.Templates/tests/Get-BicepParameterViolations.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Get-BicepParameterViolations' -Tag 'L0', 'logic' {`, written with `#`.

```text
Logic tests for Get-BicepParameterViolations (with its per-entry and Key Vault reference checks): each violation kind
against a fixture main.json (tests/assets/parameter-model/main.json, widget/gadget parameters —
[ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](/docs/adr/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)) and a rendered parameters file each
test writes, plus a clean case. No az: main.json is written as a current build, so the model is read without
building. Discovery binds to the fixture templates ('sample', configs alpha/beta) and the output to this file's
$TestDrive through the seams ([ADR-PWSH-PESTER-ISOLATETHROUGHSEAMS](/docs/adr/automation/pwsh/pester-testing.md#rule-adr-pwsh-pester-isolatethroughseams)).
```

## comment:2

Above `function New-ConformingParameterSet {`, written with `#`.

```text
A parameters file that satisfies the fixture model: every required parameter, a Key Vault reference for the
secure one. Each test starts from it and changes one thing.
```
