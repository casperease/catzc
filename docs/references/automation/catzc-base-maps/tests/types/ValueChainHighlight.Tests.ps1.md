---
catzc:
  derived:
    path: docs/references/automation/catzc-base-maps/tests/types/ValueChainHighlight.Tests.ps1.md
    folder: docs/references/automation/catzc-base-maps/tests/types
    name: value-chain-highlight-tests-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "006d9437695a"
    adrs:
      - ADR-AUTO-TEST#3
      - ADR-DSGN-TRACK#{12,16}
---

# automation/Catzc.Base.Maps/tests/types/ValueChainHighlight.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'ValueChainHighlight' -Tag 'L0', 'logic' {`, written with `#`.

```text
ValueChainHighlight lights the value-chain map cells an ADR, or one of its rules, sits in
([ADR-DSGN-TRACK#12](/docs/adr/design/tracks.md#rule-adr-dsgn-track12),
[ADR-DSGN-TRACK#16](/docs/adr/design/tracks.md#rule-adr-dsgn-track16)), with widget/gadget fixtures
([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```
