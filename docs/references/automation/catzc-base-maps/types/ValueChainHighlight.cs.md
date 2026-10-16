---
catzc:
  immutable:
    with_body_sha: "870806179829"
    path: docs/references/automation/catzc-base-maps/types/ValueChainHighlight.cs.md
    folder: docs/references/automation/catzc-base-maps/types
    name: value-chain-highlight-cs
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
  edges:
    cites:
      - ADR-DSGN-TRACK#{12,16}
      - ADR-THES-ONETRUTH#3
---

# automation/Catzc.Base.Maps/types/ValueChainHighlight.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
A value-chain highlight: the lit cells of the value-chain map for ADR references
([ADR-DSGN-TRACK#16](/docs/adr/design/tracks.md#rule-adr-dsgn-track16),
[ADR-DSGN-TRACK#12](/docs/adr/design/tracks.md#rule-adr-dsgn-track12)). A reference is ADR-<CODE>, or one rule as
ADR-<CODE>#n or ADR-<CODE>:n; a rule sits where its ADR sits, so it lights its ADR's cells. Each lit cell lists the
requested ADRs that light it, with a ValueChainReason per ADR (its ADR domain's row, the concern, and whether the
concerns are the ADR's own override or its ADR domain's default). The cells keep the map's order (rows, then
columns), so the result is deterministic; ToJson is its data form
([ADR-THES-ONETRUTH#3](/docs/adr/thesis/one-source-of-truth.md#rule-adr-thes-onetruth3)).
```
