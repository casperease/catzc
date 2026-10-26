# pwsh/Base.Maps/tests/Get-ValueChainMap.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Get-ValueChainMap'`, written with `#`.

```text
Get-ValueChainMap builds the value-chain map from the registry's closed sets and its ADRs
([DDR-TRACK-VALUECHAINMAP](/docs/drs/design/tracks.md#rule-ddr-track-valuechainmap)). The logic tests mock the ADRs with
widget/gadget fixtures ([ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](/docs/drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)); the axes are
the closed sets DrsConfig declares, read from the type, never spelled out here.
```

## comment:2

Above `Describe 'Get-ValueChainMap — the real registry'`, written with `#`.

```text
The registry's own value-chain map. It reads only drs.yml, so its answer cannot differ between the run modes
(source-only).
```
