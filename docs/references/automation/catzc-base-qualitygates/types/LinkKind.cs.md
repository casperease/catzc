---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/types/LinkKind.cs.md
    kind: reference
    body_sha: "06c3fe5dd6b5"
    adrs:
      - ADR-REPO-LINK#1
---

# automation/Catzc.Base.QualityGates/types/LinkKind.cs

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `using System;`.

```text
The two kinds of link ([ADR-REPO-LINK#1](/docs/adr/repository/markdown-links.md#rule-adr-repo-link1)), fixed by the file a link lives in:
a markdown link lives in a rendered
.md file, a code link in a comment of any other tracked text file. [Flags], so Both is Code | Markdown and the
engine tests HasFlag instead of special-casing Both; a parameter typed as this enum binds -Kind Code,
-Kind Markdown, or -Kind Both and tab-completes the fixed set.
```
