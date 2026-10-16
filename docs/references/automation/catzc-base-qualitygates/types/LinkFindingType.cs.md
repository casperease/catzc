---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/types/LinkFindingType.cs.md
    folder: docs/references/automation/catzc-base-qualitygates/types
    name: link-finding-type-cs
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "19d36db4ee84"
---

# automation/Catzc.Base.QualityGates/types/LinkFindingType.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `namespace Catzc.Base.QualityGates;`, written with `//`.

```text
What the link engine found at one place in a file
([ADR-REPO-LINK](/docs/adr/repository/markdown-links.md)). The fixable types are rewritten by
Format-Links and reported by Test-Links until they are; the rest cannot be fixed mechanically and need a
person. Overlong is informational: a line that stays over its limit after the aligner did what it can.
```
