# automation/Catzc.Base.Maps/types/ValueChainMap.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
The value-chain map: the rows of the value-chain stack crossed with the value-chain concerns, every cell of that grid,
and the ADRs each cell holds ([ADR-DSGN-TRACK#16](/docs/adr/design/tracks.md#rule-adr-dsgn-track16)). An ADR sits on
its ADR domain's row (AdrRuleSet.Stack, [ADR-DSGN-TRACK#14](/docs/adr/design/tracks.md#rule-adr-dsgn-track14)) in the
column of each of its value-chain concerns (AdrRuleSet.Concerns, an override or its ADR domain's default,
[ADR-DSGN-TRACK#15](/docs/adr/design/tracks.md#rule-adr-dsgn-track15)), so it sits in one or more cells of one row.

Build takes the axes and the ADRs (Get-ValueChainMap passes AdrsConfig.Stacks, AdrsConfig.Concerns and the adrs.yml
rule-sets). The AdrsConfig load rejects an unknown row or value-chain concern, so on the registry every ADR sits in a
cell; the map still records what it cannot place instead of dropping it: Strays names each row or value-chain concern
an ADR declares that the axes lack, and Unplaced each ADR that sits in no cell. Test-ValueChainMap reports both.

The order is deterministic: rows and columns as given, cells row by row, the ADRs of a cell in the given order. ToJson
is its data form ([ADR-THES-ONETRUTH#3](/docs/adr/thesis/one-source-of-truth.md#rule-adr-thes-onetruth3)).
```

## comment:2

Above `public static ValueChainMap Build(IEnumerable stacks, IEnumerable concerns,...`, written with `//`.

```text
The map of the given rows, columns and ADRs (Catzc.Base.Docs.AdrRuleSet items). An empty or repeated axis name, an
item that is not an AdrRuleSet, or a repeated ADR code throws.
```
