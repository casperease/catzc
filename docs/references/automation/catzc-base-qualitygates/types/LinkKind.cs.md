---
catzc:
  immutable:
    with_body_sha: "8333c7b0fe8a"
    path: docs/references/automation/catzc-base-qualitygates/types/LinkKind.cs.md
    folder: docs/references/automation/catzc-base-qualitygates/types
    name: link-kind-cs
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
  edges:
    cites:
      - ADR-REPO-LINK#1
---

# automation/Catzc.Base.QualityGates/types/LinkKind.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
The two kinds of link ([ADR-REPO-LINK#1](/docs/adr/repository/markdown-links.md#rule-adr-repo-link1)), fixed by the file a link lives in:
a markdown link lives in a rendered
.md file, a code link in a comment of any other tracked text file. [Flags], so Both is Code | Markdown and the
engine tests HasFlag instead of special-casing Both; a parameter typed as this enum binds -Kind Code,
-Kind Markdown, or -Kind Both and tab-completes the fixed set.
```
