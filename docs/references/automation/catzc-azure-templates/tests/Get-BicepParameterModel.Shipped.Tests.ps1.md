---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-templates/tests/Get-BicepParameterModel.Shipped.Tests.ps1.md
    kind: test-asset
    body_sha: "8cd57b81c81a"
    adrs:
      - ADR-AUTO-TEST#17
      - ADR-AUTO-TEST#19
      - ADR-AUTO-TEST#26
      - ADR-AUTO-TEST#37
      - ADR-AUTO-TEST#8
      - ADR-AZ-DATAMOD#9
      - ADR-PWSH-PESTER#2
---

# automation/Catzc.Azure.Templates/tests/Get-BicepParameterModel.Shipped.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `BeforeDiscovery {`.

```text
L2 integrity for the SHIPPED bicep templates' parameter contract
([ADR-AZ-DATAMOD#9](/docs/adr/azure/azure-data-model.md#rule-adr-az-datamod9)): every template is built with the
real `az bicep build`, and every parameters file it renders must satisfy the parameter model of its compiled main.json
— types, @allowed values, bounds, required parameters, no undeclared parameter, and a Key Vault reference (never a
literal) for a secure parameter. Get-BicepParameterViolations does the checking; its rules are proven on fixtures at
L0 (Get-BicepParameterViolations.Tests.ps1). This file adds what only the real compiler can: the contract the shipped
templates actually declare.

Generic over the template set ([ADR-AUTO-TEST#17](/docs/adr/automation/test-automation.md#rule-adr-auto-test17)): the
templates are discovered with Get-BicepTemplateNames, one test each, and no test names a template or asserts a
production value. It runs in the `infrastructure` globset's test suite
([ADR-AUTO-TEST#37](/docs/adr/automation/test-automation.md#rule-adr-auto-test37)) —
`Test-Automation -Suite infrastructure` — with the rest of the module's tests.

Each test self-skips when `az` is absent ([ADR-AUTO-TEST#8](/docs/adr/automation/test-automation.md#rule-adr-auto-test8)).
The build output goes to this file's $TestDrive through the Get-BicepTemplatesOutputRoot seam
([ADR-PWSH-PESTER#2](/docs/adr/pwsh/pester-testing.md#rule-adr-pwsh-pester2)), so it never shares
out/template/<name> with another test file or a developer's build. greedy, not serial: it drives real
`az bicep build` child processes but shares no mutable state
([ADR-AUTO-TEST#26](/docs/adr/automation/test-automation.md#rule-adr-auto-test26)).
```

## comment:2

Above `if (Get-Command az -ErrorAction Ignore) {`.

```text
The Bicep CLI is verified once here for the whole template set, not once per Build-Bicep call
([ADR-AUTO-TEST#19](/docs/adr/automation/test-automation.md#rule-adr-auto-test19)): each probe is a 2 s `az bicep version`
child process, and every build still compiles with the real `az bicep build`.
```
