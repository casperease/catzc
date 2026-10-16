---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/types/LinkFinding.cs.md
    kind: comment-page
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: db9f99c1c594
---

# automation/Catzc.Base.QualityGates/types/LinkFinding.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System.Globalization;`, written with `//`.

```text
One finding of the link engine: where (repository-relative file, 1-based line and column), which link kind,
what was found, a human message, and the replacement text the aligner writes (empty when it cannot fix it).
```
