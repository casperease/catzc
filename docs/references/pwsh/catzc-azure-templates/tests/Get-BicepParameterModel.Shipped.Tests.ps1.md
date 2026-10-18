# pwsh/Catzc.Azure.Templates/tests/Get-BicepParameterModel.Shipped.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `BeforeDiscovery {`, written with `#`.

```text
L2 integrity for the SHIPPED bicep templates' parameter contract
([ADR-AZ-DATAMOD-PARAMETERCONTRACT](/docs/adr/azure/azure-data-model.md#rule-adr-az-datamod-parametercontract)): every template is built with the
real `az bicep build`, and every parameters file it renders must satisfy the parameter model of its compiled main.json
— types, @allowed values, bounds, required parameters, no undeclared parameter, and a Key Vault reference (never a
literal) for a secure parameter. Get-BicepParameterViolations does the checking; its rules are proven on fixtures at
L0 (Get-BicepParameterViolations.Tests.ps1). This file adds what only the real compiler can: the contract the shipped
templates actually declare.

Generic over the template set ([ADR-AUTO-TEST-GENERICTEMPLATETESTS](/docs/adr/automation/test-automation.md#rule-adr-auto-test-generictemplatetests)): the
templates are discovered with Get-BicepTemplateNames, one test each, and no test names a template or asserts a
production value. It runs in the `infrastructure` globset's test suite
([ADR-AUTO-TEST-TESTSUITE](/docs/adr/automation/test-automation.md#rule-adr-auto-test-testsuite)) —
`Test-Automation -Suite infrastructure` — with the rest of the module's tests.

Each test self-skips when `az` is absent ([ADR-AUTO-TEST-TAGBYOUTERMOSTRING](/docs/adr/automation/test-automation.md#rule-adr-auto-test-tagbyoutermostring)).
The build output goes to this file's $TestDrive through the Get-BicepTemplatesOutputRoot seam
([ADR-PWSH-PESTER-ISOLATETHROUGHSEAMS](/docs/adr/pwsh/pester-testing.md#rule-adr-pwsh-pester-isolatethroughseams)), so it never shares
out/template/<name> with another test file or a developer's build. greedy, not serial: it drives real
`az bicep build` child processes but shares no mutable state
([ADR-AUTO-TEST-ONESCHEDULINGPOOL](/docs/adr/automation/test-automation.md#rule-adr-auto-test-oneschedulingpool)).
```

## comment:2

Above `if (Get-Command az -ErrorAction Ignore) {`, written with `#`.

```text
The Bicep CLI is verified once here for the whole template set, not once per Build-Bicep call
([ADR-AUTO-TEST-SETUPONCE](/docs/adr/automation/test-automation.md#rule-adr-auto-test-setuponce)): each probe is a 2 s `az bicep version`
child process, and every build still compiles with the real `az bicep build`.
```
