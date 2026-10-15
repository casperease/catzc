# docs/references/automation/catzc-base-maps/Get-ValueChainMap.ps1.md

`automation/Catzc.Base.Maps/Get-ValueChainMap.ps1`

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Builds the value-chain map ([ADR-DSGN-TRACK#16](/docs/adr/design/tracks.md#rule-adr-dsgn-track16)) with
Catzc.Base.Maps.ValueChainMap from adrs.yml: the rows are the value-chain stack the registry type declares
(Catzc.Base.Docs.AdrsConfig Stacks, [ADR-DSGN-TRACK#14](/docs/adr/design/tracks.md#rule-adr-dsgn-track14)), the
columns its value-chain concerns (AdrsConfig Concerns,
[ADR-DSGN-TRACK#15](/docs/adr/design/tracks.md#rule-adr-dsgn-track15)), and each ADR (Get-AdrRuleSet) sits on
its ADR domain's row in the column of each of its value-chain concerns. Every row meets every column, so the map
holds every cell, empty ones included, row by row.
```

## comment:2

Section `.PARAMETER AsJson` of the comment-based help.

```text
Return the map as JSON (the rows, the columns, and every cell with its ADRs) instead of the object
([ADR-THES-ONETRUTH#3](/docs/adr/thesis/one-source-of-truth.md#rule-adr-thes-onetruth3)).
```
