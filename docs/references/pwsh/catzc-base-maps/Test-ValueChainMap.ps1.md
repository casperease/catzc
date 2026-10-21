# pwsh/Catzc.Base.Maps/Test-ValueChainMap.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Quality gate: every ADR sits in a cell of the value-chain map, and every label the value-chain map prints is a glossary term.

### description

A quality gate ([ADR-AUTO-TEST-QUALITYGATE](../../../drs/automation/test-automation.md#rule-adr-auto-test-qualitygate)) over the value-chain
map that Get-ValueChainMap returns; it reads the map and never places an ADR itself. It is a sibling of Test-WorldMap, not a part of it: a
quality gate checks one property, and the value-chain map is read from drs.yml alone, while the world map is read from the git index
([ADR-AUTO-ONEJOB](../../../drs/automation/single-responsibility-functions.md)). It checks four things, and every finding is one issue:

- The rows. The map prints the rows of the value-chain stack, the closed set Catzc.Base.Drs.DrsConfig Stacks declares, in order
  ([DDR-TRACK-VALUECHAINSTACK](../../../drs/design/tracks.md#rule-ddr-track-valuechainstack)).
- The columns. The map prints the value-chain concerns, the closed set DrsConfig Concerns declares, in order
  ([DDR-TRACK-VALUECHAINCONCERN](../../../drs/design/tracks.md#rule-ddr-track-valuechainconcern)). Row and column names are
  members of those closed sets, so they are checked against them, never against the glossary.
- The ADRs. Every ADR sits in at least one cell, and every row and value-chain concern it declares is one the map prints
  ([DDR-TRACK-VALUECHAINCONCERN](../../../drs/design/tracks.md#rule-ddr-track-valuechainconcern)). The drs.yml load rejects an
  unknown value, so this guards the map's reading of the registry.
- Printed labels. Each value_chain_ label of maps.yml (Get-Config -Config maps) names a glossary term (Get-Glossary) in its head, the text
  before its first ':' (Resolve-MapLabelTerm,
  [DDR-TRACK-VALUECHAINMAP](../../../drs/design/tracks.md#rule-ddr-track-valuechainmap)).

It ends through Write-QualityGateReport: the report goes to out/test-value-chain-map/, every issue is printed, and the quality gate throws
once listing them all; -PassThru returns the result instead.

### parameter `OutputFolder`

The report base folder. Defaults to out/test-value-chain-map/ (Write-QualityGateReport).

### parameter `PassThru`

Return the result ({ Subject; IssueCount; Issues; ReportPath; Adrs; Rows; Columns; NonEmptyCells; Labels }) instead of throwing on issues.
NonEmptyCells counts the cells that hold at least one ADR, and Labels the printed labels checked.

### outputs

`[Catzc.Base.Reports.QualityGateResult]` With -PassThru only.

### example 1

```powershell
Test-ValueChainMap
```

### example 2

```powershell
(Test-ValueChainMap -PassThru).Issues
```
