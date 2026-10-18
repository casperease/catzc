# pwsh/Catzc.Base.QualityGates/tests/Get-TestTagViolations.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Mock Get-CatsAdrRuleIds { @('ADR-WIDGET-GADGET-TURN',...`, written with `#`.

```text
A fixture rule-id set so the validation is hermetic — it never reads the
shipped ADR tree. Mocking the whole boundary function is the seam
([ADR-AUTO-TEST](/docs/adr/automation/test-automation.md)).
```

## comment:2

Above `function New-Discovery {`, written with `#`.

```text
The fake discovery is plain data, so it is built here (Pester scope) and passed INTO InModuleScope
via -Parameters — a function defined here is not visible in the module's session state.
```
