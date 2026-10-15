---
catzc:
  derived:
    path: docs/references/automation/catzc-base-variants/Get-Track.ps1.md
    kind: reference
    body_sha: "776683384059"
    adrs:
      - ADR-DSGN-TRACK#1
      - ADR-DSGN-TRACK#2
      - ADR-DSGN-TRACK#6
---

# automation/Catzc.Base.Variants/Get-Track.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The `tracks` repo-wide variant (configs/variants.yml, [ADR-DSGN-TRACK](/docs/adr/design/tracks.md)) declares each
track: its root folder, its class (core, adapter, external-port, verification or unordered,
[ADR-DSGN-TRACK#2](/docs/adr/design/tracks.md#rule-adr-dsgn-track2)) and the file languages of its tech-stack
([ADR-DSGN-TRACK#6](/docs/adr/design/tracks.md#rule-adr-dsgn-track6)). Each result is a VariantTrack, in declared
order; the shape is validated by the VariantsConfig type.

-Path answers "which track does this file belong to?"
([ADR-DSGN-TRACK#1](/docs/adr/design/tracks.md#rule-adr-dsgn-track1)): the track whose root is the path's first
segment (a bare root folder, e.g. 'docs', is its own track's path). A file at the repository root, a path under
out/ (gitignored output, never a track), and a root folder no track declares return nothing.
```
