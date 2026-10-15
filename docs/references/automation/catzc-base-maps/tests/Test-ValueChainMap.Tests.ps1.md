---
catzc:
  derived:
    path: docs/references/automation/catzc-base-maps/tests/Test-ValueChainMap.Tests.ps1.md
    kind: test-asset
    body_sha: "04ffdccc0746"
    adrs:
      - ADR-AUTO-TEST#3
      - ADR-AUTO-TEST#35
      - ADR-DSGN-TRACK#14
      - ADR-DSGN-TRACK#15
      - ADR-DSGN-TRACK#16
---

# automation/Catzc.Base.Maps/tests/Test-ValueChainMap.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'Test-ValueChainMap' -Tag 'L0', 'logic' {`.

```text
Test-ValueChainMap reads the value-chain map Get-ValueChainMap returns and reports axes that are not the registry's
closed sets ([ADR-DSGN-TRACK#14](/docs/adr/design/tracks.md#rule-adr-dsgn-track14),
[ADR-DSGN-TRACK#15](/docs/adr/design/tracks.md#rule-adr-dsgn-track15)), ADRs it cannot place, and value_chain_
labels that name no glossary term ([ADR-DSGN-TRACK#16](/docs/adr/design/tracks.md#rule-adr-dsgn-track16)), through
Write-QualityGateReport ([ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35)). The logic
tests mock the map, the glossary and the labels with widget/gadget fixtures
([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)); the clean map's axes are the closed
sets AdrsConfig declares, read from the type.
```

## comment:2

Above `Describe 'Test-ValueChainMap on the repository' -Tag 'L1', 'integrity',...`.

```text
The registry's own value-chain map, through the quality gate. It reads only adrs.yml and maps.yml, so its answer
cannot differ between the run modes (source-only).
```
