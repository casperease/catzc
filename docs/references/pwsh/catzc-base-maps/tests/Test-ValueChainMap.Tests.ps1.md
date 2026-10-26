# pwsh/Base.Maps/tests/Test-ValueChainMap.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Test-ValueChainMap'`, written with `#`.

```text
Test-ValueChainMap reads the value-chain map Get-ValueChainMap returns and reports axes that are not the registry's
closed sets ([DDR-TRACK-VALUECHAINSTACK](/docs/drs/design/tracks.md#rule-ddr-track-valuechainstack),
[DDR-TRACK-VALUECHAINCONCERN](/docs/drs/design/tracks.md#rule-ddr-track-valuechainconcern)), ADRs it cannot place, and value_chain_
labels that name no glossary term ([DDR-TRACK-VALUECHAINMAP](/docs/drs/design/tracks.md#rule-ddr-track-valuechainmap)), through
Write-QualityGateReport ([ADR-AUTO-TEST-QUALITYGATE](/docs/drs/automation/test-automation.md#rule-adr-auto-test-qualitygate)). The logic
tests mock the map, the glossary and the labels with widget/gadget fixtures
([ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](/docs/drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)); the clean map's axes are the closed
sets DrsConfig declares, read from the type.
```

## comment:2

Above `Describe 'Test-ValueChainMap on the repository'`, written with `#`.

```text
The registry's own value-chain map, through the quality gate. It reads only drs.yml and maps.yml, so its answer
cannot differ between the run modes (source-only).
```
