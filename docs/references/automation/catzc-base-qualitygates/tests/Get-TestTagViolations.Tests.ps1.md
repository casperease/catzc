---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/tests/Get-TestTagViolations.Tests.ps1.md
    kind: test-asset
    body_sha: "6121981f574a"
---

# automation/Catzc.Base.QualityGates/tests/Get-TestTagViolations.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Mock Get-CatsAdrRuleIds { @('ADR-WIDGET-GADGET:3', 'ADR-WIDGET-SPROCKET:1') }...`.

```text
A fixture rule-id set (registry ':' form) so the validation is hermetic — it never reads the
shipped ADR tree. Mocking the whole boundary function is the seam
([ADR-AUTO-TEST](/docs/adr/automation/test-automation.md)).
```

## comment:2

Above `function New-Discovery {`.

```text
The fake discovery is plain data, so it is built here (Pester scope) and passed INTO InModuleScope
via -Parameters — a function defined here is not visible in the module's session state.
```
