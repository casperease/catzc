---
catzc:
  derived:
    path: docs/references/automation/catzc-base-docs/tests/Get-AdrCitationGraphViolations.Tests.ps1.md
    kind: test-asset
    body_sha: e499fb07b231
    adrs:
      - ADR-AUTO-TEST#3
---

# automation/Catzc.Base.Docs/tests/Get-AdrCitationGraphViolations.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'Get-AdrCitationGraphViolations' -Tag 'L0', 'logic',...`.

```text
Get-AdrCitationGraphViolations — a rule summary cites only its own domain or a domain its domain depends on, read as declared (not
transitively); prose outside the rule registry is not read. A fixture tree in $TestDrive and a fixture registry, widget <- gadget
<- gizmo; neutral fixture codes ([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```
