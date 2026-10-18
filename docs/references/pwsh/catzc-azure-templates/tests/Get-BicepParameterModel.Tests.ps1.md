# pwsh/Catzc.Azure.Templates/tests/Get-BicepParameterModel.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Get-BicepParameterModel' -Tag 'L0', 'logic' {`, written with `#`.

```text
Logic tests for Get-BicepParameterModel and the BicepParameterModel/BicepParameter types it returns: the model parsed
from a fixture main.json (tests/assets/parameter-model/main.json, widget/gadget parameters —
[ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](/docs/adr/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)), and the build-when-not-current
decision. No az: the fixture stands in for the compiled main.json, and Build-Bicep (the one az touch) is mocked.
Discovery binds to the fixture templates and the output to this file's $TestDrive through the seams
([ADR-PWSH-PESTER-ISOLATETHROUGHSEAMS](/docs/adr/pwsh/pester-testing.md#rule-adr-pwsh-pester-isolatethroughseams)).
```

## comment:2

Above `function Write-FixtureBuild {`, written with `#`.

```text
Written, not copied: a copy keeps the source's timestamp, and the model reads a build as current only when
main.json is at least as new as the template's inputs.
```
