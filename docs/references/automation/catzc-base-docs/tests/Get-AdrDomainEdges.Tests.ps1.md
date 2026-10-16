---
catzc:
  derived:
    path: docs/references/automation/catzc-base-docs/tests/Get-AdrDomainEdges.Tests.ps1.md
    kind: comment-page
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "7a485b732122"
    adrs:
      - ADR-AUTO-TEST#3
---

# automation/Catzc.Base.Docs/tests/Get-AdrDomainEdges.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Get-AdrDomainEdges' -Tag 'L0', 'logic' {`, written with `#`.

```text
Get-AdrDomainEdges over a fixture AdrsConfig (Get-Config mocked): the registry's own construction holds the
edge invariants (declared ends, no self-edge, acyclic), so this pins only the projection. Neutral fixture names
([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```
