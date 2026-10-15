---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/types/CommentBlock.cs.md
    kind: reference
    body_sha: ee76455745cd
    adrs:
      - ADR-AUTO-TYPES#9
---

# automation/Catzc.Base.QualityGates/types/CommentBlock.cs

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `using System;`.

```text
One comment block CommentEngine found in a file and may move to the file's comment page: where it is (whole
lines, 0-based, inclusive), how it is written (kind, indent, marker), its prose with the comment prefix stripped,
and the context the page names so a reader knows what it annotated. Every property is fixed at construction; the
engine is pure over text ([ADR-AUTO-TYPES#9](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types9)).
```

## comment:2

Above `public static string CodeSpan(string text)`.

```text
A Markdown code span that holds the text verbatim, backticks included: its fence is one backtick longer than the
longest run inside, and it is padded with a space only when the text starts or ends with a backtick.
```
