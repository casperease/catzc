---
catzc:
  derived:
    path: docs/references/automation/catzc-base-maps/tests/Get-ValueChainHighlight.Tests.ps1.md
    kind: test-asset
    body_sha: "1536a34d3925"
    adrs:
      - ADR-AUTO-TEST#3
      - ADR-DSGN-TRACK#12
      - ADR-DSGN-TRACK#16
---

# automation/Catzc.Base.Maps/tests/Get-ValueChainHighlight.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'Get-ValueChainHighlight' -Tag 'L0', 'logic' {`.

```text
Get-ValueChainHighlight lights the value-chain map cells of ADR codes
([ADR-DSGN-TRACK#12](/docs/adr/design/tracks.md#rule-adr-dsgn-track12),
[ADR-DSGN-TRACK#16](/docs/adr/design/tracks.md#rule-adr-dsgn-track16)). The logic tests mock the map with
widget/gadget fixtures ([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```
