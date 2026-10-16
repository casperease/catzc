---
catzc:
  immutable:
    with_body_sha: "8b3b701b1c4c"
    path: docs/references/automation/catzc-base-maps/tests/types/ValueChainMap.Tests.ps1.md
    folder: docs/references/automation/catzc-base-maps/tests/types
    name: value-chain-map-tests-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
  edges:
    cites:
      - ADR-AUTO-TEST#3
      - ADR-DSGN-TRACK#16
---

# automation/Catzc.Base.Maps/tests/types/ValueChainMap.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'ValueChainMap' -Tag 'L0', 'logic' {`, written with `#`.

```text
ValueChainMap places each ADR on its ADR domain's row in the column of each of its value-chain concerns
([ADR-DSGN-TRACK#16](/docs/adr/design/tracks.md#rule-adr-dsgn-track16)), with widget/gadget fixtures
([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```
