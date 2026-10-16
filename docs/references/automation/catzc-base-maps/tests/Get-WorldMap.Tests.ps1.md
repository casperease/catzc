---
catzc:
  derived:
    path: docs/references/automation/catzc-base-maps/tests/Get-WorldMap.Tests.ps1.md
    folder: docs/references/automation/catzc-base-maps/tests
    name: get-world-map-tests-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: e36637796aaa
    adrs:
      - ADR-DSGN-TRACK#3
---

# automation/Catzc.Base.Maps/tests/Get-WorldMap.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Get-WorldMap — the real repository' -Tag 'L1', 'integrity',...`, written with `#`.

```text
The real repository: every tracked file of the git index gets a cell, and no live file breaks its track's
tech-stack ([ADR-DSGN-TRACK#3](/docs/adr/design/tracks.md#rule-adr-dsgn-track3)).
```
