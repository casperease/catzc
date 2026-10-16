---
catzc:
  derived:
    path: docs/references/automation/catzc-base-maps/tests/Get-ValueChainMap.Tests.ps1.md
    kind: comment-page
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: e8dcecdf1195
    adrs:
      - ADR-AUTO-TEST#3
      - ADR-DSGN-TRACK#16
---

# automation/Catzc.Base.Maps/tests/Get-ValueChainMap.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Get-ValueChainMap' -Tag 'L0', 'logic' {`, written with `#`.

```text
Get-ValueChainMap builds the value-chain map from the registry's closed sets and its ADRs
([ADR-DSGN-TRACK#16](/docs/adr/design/tracks.md#rule-adr-dsgn-track16)). The logic tests mock the ADRs with
widget/gadget fixtures ([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)); the axes are
the closed sets AdrsConfig declares, read from the type, never spelled out here.
```

## comment:2

Above `Describe 'Get-ValueChainMap — the real registry' -Tag 'L1', 'integrity',...`, written with `#`.

```text
The registry's own value-chain map. It reads only adrs.yml, so its answer cannot differ between the run modes
(source-only).
```
