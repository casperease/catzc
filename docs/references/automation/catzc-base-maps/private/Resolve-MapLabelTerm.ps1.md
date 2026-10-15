---
catzc:
  derived:
    path: docs/references/automation/catzc-base-maps/private/Resolve-MapLabelTerm.ps1.md
    kind: comment-page
    body_sha: "87b577ef2ef2"
    adrs:
      - ADR-DSGN-TRACK#13
      - ADR-DSGN-TRACK#16
---

# automation/Catzc.Base.Maps/private/Resolve-MapLabelTerm.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
A label names the concept it prints in its head: the text before its first ':', trimmed ('World map' in
'World map: repository tree'), or the whole label when it has no ':'. The head resolves when, compared without
case, it is a term of -Term or that term's plural (the term followed by 's' or 'es': 'Root files' names the term
'root file'). Every label the world map or the value-chain map prints names a defined term in its head
([ADR-DSGN-TRACK#13](/docs/adr/design/tracks.md#rule-adr-dsgn-track13),
[ADR-DSGN-TRACK#16](/docs/adr/design/tracks.md#rule-adr-dsgn-track16)), so Test-WorldMap and Test-ValueChainMap
report a label this returns nothing for.
```
