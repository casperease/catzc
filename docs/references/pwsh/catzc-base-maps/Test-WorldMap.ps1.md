# pwsh/Catzc.Base.Maps/Test-WorldMap.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Quality gate: every tracked file sits in a declared track and its tech-stack, and every label the world map prints is a glossary term.

### description

A quality gate ([ADR-AUTO-TEST-QUALITYGATE](../../../adr/automation/test-automation.md#rule-adr-auto-test-qualitygate)) over the world map
that Get-WorldMap returns; it reads the map's placements and never places a file itself. It checks three things, and every finding is one
issue:

- Stack violations. A cell that holds a live file whose file language its track does not declare is a second tech-stack inside the track
  ([ADR-DSGN-TRACK-ONETECHSTACK](../../../adr/design/tracks.md#rule-adr-dsgn-track-onetechstack)): one issue per cell, with its file count
  and its first file in ordinal order.
- Undeclared root folders. A root folder that holds a tracked file names a track, except out/, which holds gitignored output
  ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER](../../../adr/design/tracks.md#rule-adr-dsgn-track-trackisplacedcluster),
  [ADR-REPO-OUTDIR](../../../adr/repository/dedicated-output-directory.md)). The map places the files of any other root folder no track
  names among the root files: one issue per such folder, with its file count.
- Printed labels. Every label the world map prints names a defined term
  ([ADR-DSGN-TRACK-LABELSNAMEDEFINEDTERMS](../../../adr/design/tracks.md#rule-adr-dsgn-track-labelsnamedefinedterms)): each world-map label
  of maps.yml (Get-Config -Config maps; the value_chain_ labels are Test-ValueChainMap's) names a glossary term (Get-Glossary) in its head,
  the text before its first ':' (Resolve-MapLabelTerm). A row prints a track's name and a column a file language's name, so the names
  resolve through their axis's term: the glossary holds 'track'
  ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER](../../../adr/design/tracks.md#rule-adr-dsgn-track-trackisplacedcluster)) and 'file language'
  ([ADR-DSGN-TRACK-FILELANGUAGE](../../../adr/design/tracks.md#rule-adr-dsgn-track-filelanguage)). The two catch-all lines print their
  labels, root_files and unlisted_files, which the maps.yml check covers.

It ends through Write-QualityGateReport: the report goes to out/test-world-map/, every issue is printed, and the quality gate throws once
listing them all; -PassThru returns the result instead.

### parameter `OutputFolder`

The report base folder. Defaults to out/test-world-map/ (Write-QualityGateReport).

### parameter `PassThru`

Return the result ({ Subject; IssueCount; Issues; ReportPath; Files; Tracks; FileLanguages; StackViolations; Labels }) instead of throwing
on issues. StackViolations counts the files that break their track's tech-stack, and Labels the printed labels checked.

### outputs

`[Catzc.Base.Reports.QualityGateResult]` With -PassThru only.

### example 1

```powershell
Test-WorldMap
```

### example 2

```powershell
(Test-WorldMap -PassThru).Issues
```
