---
catzc:
  derived:
    path: docs/references/automation/catzc-base-maps/types/ValueChainHighlight.cs.md
    kind: comment-page
    body_sha: "409d2c8e752d"
    adrs:
      - ADR-DSGN-TRACK#12
      - ADR-DSGN-TRACK#16
      - ADR-THES-ONETRUTH#3
---

# automation/Catzc.Base.Maps/types/ValueChainHighlight.cs

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `using System;`.

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
