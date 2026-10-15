---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-inspiration/tests/Get-Inspiration.Tests.ps1.md
    kind: test-asset
    body_sha: "983a2181a240"
    adrs:
      - ADR-AUTO-TEST#3
      - ADR-REPO-INSPIRE#1
---

# automation/Catzc.Tooling.Inspiration/tests/Get-Inspiration.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'Get-Inspiration' -Tag 'L0', 'logic' {`.

```text
Get-Inspiration over a fixture config (Get-Config mocked to the real InspirationConfig built from neutral widget/gadget
data, [ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)) and a TestDrive workspace in
which widget and gadget exist and gizmo does not. An inspiration that is absent is reported, never thrown on
([ADR-REPO-INSPIRE#1](/docs/adr/repository/inspiration.md#rule-adr-repo-inspire1)).
```
