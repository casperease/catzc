---
catzc:
  derived:
    path: docs/references/automation/catzc-base-docs/types/AdrCitationChangeKind.cs.md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "73213c43613b"
    adrs:
      - ADR-AUTO-TYPES#9
---

# automation/Catzc.Base.Docs/types/AdrCitationChangeKind.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `namespace Catzc.Base.Docs;`, written with `//`.

```text
What one AdrCitationChange rewrote: the closed set of ADR reference forms Update-AdrCitation recognises, plus the
one form it found and could not rewrite mechanically
([ADR-AUTO-TYPES#9](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types9)).
```
