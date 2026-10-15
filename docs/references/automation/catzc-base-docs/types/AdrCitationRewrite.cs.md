# docs/references/automation/catzc-base-docs/types/AdrCitationRewrite.cs.md

`automation/Catzc.Base.Docs/types/AdrCitationRewrite.cs`

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `using System;`.

```text
The result of rewriting one file's ADR references (AdrCitationRewriter.Rewrite): the new text and every change
made, in text order. Changed is false exactly when the text is the input unchanged, so a caller writes the file
only when it is true ([ADR-AUTO-TYPES#9](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types9)).
```
