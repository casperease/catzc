---
catzc:
  derived:
    path: docs/references/automation/catzc-base-languages/types/ImprintStep.cs.md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "57156afc1717"
    adrs:
      - ADR-REPO-FORMAT#8
---

# automation/Catzc.Base.Languages/types/ImprintStep.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
One imprint step of the file-language registry: its name, and the files whose bytes change what it writes.
[ADR-REPO-FORMAT#8](/docs/adr/repository/uniform-formatting.md#rule-adr-repo-format8)
```
