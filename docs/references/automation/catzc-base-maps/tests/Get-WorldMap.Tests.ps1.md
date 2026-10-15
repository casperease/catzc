---
catzc:
  derived:
    path: docs/references/automation/catzc-base-maps/tests/Get-WorldMap.Tests.ps1.md
    kind: test-asset
    body_sha: dc039a4590cf
    adrs:
      - ADR-DSGN-TRACK#3
---

# automation/Catzc.Base.Maps/tests/Get-WorldMap.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'Get-WorldMap — the real repository' -Tag 'L1', 'integrity',...`.

```text
The real repository: every tracked file of the git index gets a cell, and no live file breaks its track's
tech-stack ([ADR-DSGN-TRACK#3](/docs/adr/design/tracks.md#rule-adr-dsgn-track3)).
```
