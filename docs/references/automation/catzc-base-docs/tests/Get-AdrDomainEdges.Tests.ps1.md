---
catzc:
  derived:
    path: docs/references/automation/catzc-base-docs/tests/Get-AdrDomainEdges.Tests.ps1.md
    kind: test-asset
    body_sha: "0a5f3ba498e8"
    adrs:
      - ADR-AUTO-TEST#3
---

# automation/Catzc.Base.Docs/tests/Get-AdrDomainEdges.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'Get-AdrDomainEdges' -Tag 'L0', 'logic' {`.

```text
Get-AdrDomainEdges over a fixture AdrsConfig (Get-Config mocked): the registry's own construction holds the
edge invariants (declared ends, no self-edge, acyclic), so this pins only the projection. Neutral fixture names
([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```
