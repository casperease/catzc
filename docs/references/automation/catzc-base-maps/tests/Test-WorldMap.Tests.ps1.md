---
catzc:
  immutable:
    with_body_sha: a118d549d663
    path: docs/references/automation/catzc-base-maps/tests/Test-WorldMap.Tests.ps1.md
    folder: docs/references/automation/catzc-base-maps/tests
    name: test-world-map-tests-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
  edges:
    cites:
      - ADR-AUTO-TEST#{3,35}
      - ADR-DSGN-TRACK#{1,3}
---

# automation/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Test-WorldMap' -Tag 'L0', 'logic' {`, written with `#`.

```text
Test-WorldMap reads the world map Get-WorldMap returns and reports its stack violations
([ADR-DSGN-TRACK#3](/docs/adr/design/tracks.md#rule-adr-dsgn-track3)), its undeclared root folders
([ADR-DSGN-TRACK#1](/docs/adr/design/tracks.md#rule-adr-dsgn-track1)) and the printed labels that name no glossary
term, through Write-QualityGateReport
([ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35)). The logic tests mock the map, the
glossary and the labels with widget/gadget fixtures
([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)); the placement itself is pinned by
Get-WorldMap.Tests.ps1.
```

## comment:2

Above `Describe 'Test-WorldMap on the repository' -Tag 'L1', 'integrity',...`, written with `#`.

```text
The repository's own world map, through the quality gate. It reads only the git index and the registries, so its
answer cannot differ between the run modes (source-only).
```
