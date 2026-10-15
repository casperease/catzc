---
catzc:
  derived:
    path: docs/references/automation/catzc-base-maps/Test-ValueChainMap.ps1.md
    kind: comment-page
    body_sha: dab552b72ca9
    adrs:
      - ADR-AUTO-TEST#35
      - ADR-DSGN-TRACK#14
      - ADR-DSGN-TRACK#15
      - ADR-DSGN-TRACK#16
---

# automation/Catzc.Base.Maps/Test-ValueChainMap.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
A quality gate ([ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35)) over the
value-chain map that Get-ValueChainMap returns; it reads the map and never places an ADR itself. It is a sibling of
Test-WorldMap, not a part of it: a quality gate checks one property, and the value-chain map is read from adrs.yml
alone, while the world map is read from the git index
([ADR-AUTO-ONEJOB](/docs/adr/automation/single-responsibility-functions.md)). It checks four things, and every
finding is one issue:

- The rows. The map prints the rows of the value-chain stack, the closed set Catzc.Base.Docs.AdrsConfig Stacks
  declares, in order ([ADR-DSGN-TRACK#14](/docs/adr/design/tracks.md#rule-adr-dsgn-track14)).
- The columns. The map prints the value-chain concerns, the closed set AdrsConfig Concerns declares, in order
  ([ADR-DSGN-TRACK#15](/docs/adr/design/tracks.md#rule-adr-dsgn-track15)). Row and column names are members of
  those closed sets, so they are checked against them, never against the glossary.
- The ADRs. Every ADR sits in at least one cell, and every row and value-chain concern it declares is one the
  map prints ([ADR-DSGN-TRACK#15](/docs/adr/design/tracks.md#rule-adr-dsgn-track15)). The adrs.yml load rejects
  an unknown value, so this guards the map's reading of the registry.
- Printed labels. Each value_chain_ label of maps.yml (Get-Config -Config maps) names a glossary term
  (Get-Glossary) in its head, the text before its first ':' (Resolve-MapLabelTerm,
  [ADR-DSGN-TRACK#16](/docs/adr/design/tracks.md#rule-adr-dsgn-track16)).

It ends through Write-QualityGateReport: the report goes to out/test-value-chain-map/, every issue is printed, and
the quality gate throws once listing them all; -PassThru returns the result instead.
```

## comment:2

Section `.PARAMETER PassThru` of the comment-based help.

```text
Return the result ({ Subject; IssueCount; Issues; ReportPath; Adrs; Rows; Columns; NonEmptyCells; Labels })
instead of throwing on issues. NonEmptyCells counts the cells that hold at least one ADR, and Labels the printed labels
checked.
```
