---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/private/Get-LinkLineLimit.ps1.md
    kind: comment-page
    body_sha: "266f219456a7"
    adrs:
      - ADR-AUTO-DEFAULT#6
---

# automation/Catzc.Base.QualityGates/private/Get-LinkLineLimit.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Reads max_line_length from the repository's .editorconfig sections of the form [*.ext] and [*.{a,b}] — the
source of truth for formatting — then applies links.yml's line_limit overrides on top. An extension neither names
takes the config's default_line_limit
([ADR-AUTO-DEFAULT#6](/docs/adr/automation/sensible-defaults.md#rule-adr-auto-default6)), which the caller passes to
the engine separately.
```
