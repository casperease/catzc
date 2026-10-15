---
catzc:
  derived:
    path: docs/references/automation/catzc-base-maps/tests/types/ValueChainHighlight.Tests.ps1.md
    kind: test-asset
    body_sha: b7d1e1eb54b7
    adrs:
      - ADR-AUTO-TEST#3
      - ADR-DSGN-TRACK#12
      - ADR-DSGN-TRACK#16
---

# automation/Catzc.Base.Maps/tests/types/ValueChainHighlight.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'ValueChainHighlight' -Tag 'L0', 'logic' {`.

```text
ValueChainHighlight lights the value-chain map cells an ADR, or one of its rules, sits in
([ADR-DSGN-TRACK#12](/docs/adr/design/tracks.md#rule-adr-dsgn-track12),
[ADR-DSGN-TRACK#16](/docs/adr/design/tracks.md#rule-adr-dsgn-track16)), with widget/gadget fixtures
([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```
