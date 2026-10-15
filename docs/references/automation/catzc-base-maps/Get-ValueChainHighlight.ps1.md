---
catzc:
  derived:
    path: docs/references/automation/catzc-base-maps/Get-ValueChainHighlight.ps1.md
    kind: comment-page
    body_sha: abbae60cb785
    adrs:
      - ADR-DSGN-TRACK#12
      - ADR-DSGN-TRACK#16
      - ADR-THES-ONETRUTH#3
    links: []
---

# automation/Catzc.Base.Maps/Get-ValueChainHighlight.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Builds the value-chain map (Get-ValueChainMap) and lights its cells with Catzc.Base.Maps.ValueChainHighlight: each
code (ADR-<CODE>, or one rule as ADR-<CODE>#n or ADR-<CODE>:n) lights the cells its ADR sits in, its ADR domain's
row crossed with each of its value-chain concerns
([ADR-DSGN-TRACK#12](/docs/adr/design/tracks.md#rule-adr-dsgn-track12),
[ADR-DSGN-TRACK#16](/docs/adr/design/tracks.md#rule-adr-dsgn-track16)). A rule sits where its ADR sits, so a
citation of one rule lights the same cells as its ADR. Each lit cell lists the requested ADRs that light it. It is
the value-chain counterpart of Get-WorldMapHighlight -Adr, which lights where the ADR's files sit.
```

## comment:2

Section `.PARAMETER AsJson` of the comment-based help.

```text
Return the highlight as JSON (the request and the lit cells with their ADRs) instead of the object
([ADR-THES-ONETRUTH#3](/docs/adr/thesis/one-source-of-truth.md#rule-adr-thes-onetruth3)).
```
