---
catzc:
  derived:
    path: docs/references/automation/catzc-base-docs/tests/types/AdrDomainEdge.Tests.ps1.md
    kind: test-asset
    body_sha: "3ee6b089acaf"
    adrs:
      - ADR-AUTO-TEST#3
      - ADR-AUTO-TYPES#9
---

# automation/Catzc.Base.Docs/tests/types/AdrDomainEdge.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'AdrDomainEdge' -Tag 'L0', 'logic', 'ADR-AUTO-TYPES#9' {`.

```text
AdrDomainEdge — one From/To edge of the ADR domain graph; the constructor holds both ends non-empty and distinct.
Neutral fixture names ([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```
