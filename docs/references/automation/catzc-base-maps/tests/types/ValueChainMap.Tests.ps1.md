---
catzc:
  derived:
    path: docs/references/automation/catzc-base-maps/tests/types/ValueChainMap.Tests.ps1.md
    kind: test-asset
    body_sha: "75978ee3ba70"
    adrs:
      - ADR-AUTO-TEST#3
      - ADR-DSGN-TRACK#16
---

# automation/Catzc.Base.Maps/tests/types/ValueChainMap.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'ValueChainMap' -Tag 'L0', 'logic' {`.

```text
ValueChainMap places each ADR on its ADR domain's row in the column of each of its value-chain concerns
([ADR-DSGN-TRACK#16](/docs/adr/design/tracks.md#rule-adr-dsgn-track16)), with widget/gadget fixtures
([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```
