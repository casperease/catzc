# pwsh/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Test-WorldMap' -Tag 'L0', 'logic' {`, written with `#`.

```text
Test-WorldMap reads the world map Get-WorldMap returns and reports its stack violations
([DDR-TRACK-ONETECHSTACK](/docs/drs/design/tracks.md#rule-ddr-track-onetechstack)), its undeclared root folders
([DDR-TRACK-TRACKISPLACEDCLUSTER](/docs/drs/design/tracks.md#rule-ddr-track-trackisplacedcluster)) and the printed labels that name no glossary
term, through Write-QualityGateReport
([ADR-AUTO-TEST-QUALITYGATE](/docs/drs/automation/test-automation.md#rule-adr-auto-test-qualitygate)). The logic tests mock the map, the
glossary and the labels with widget/gadget fixtures
([ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](/docs/drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)); the placement itself is pinned by
Get-WorldMap.Tests.ps1.
```

## comment:2

Above `Describe 'Test-WorldMap on the repository' -Tag 'L1', 'integrity',...`, written with `#`.

```text
The repository's own world map, through the quality gate. It reads only the git index and the registries, so its
answer cannot differ between the run modes (source-only).
```
