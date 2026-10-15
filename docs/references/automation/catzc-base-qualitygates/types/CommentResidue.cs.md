# docs/references/automation/catzc-base-qualitygates/types/CommentResidue.cs.md

`automation/Catzc.Base.QualityGates/types/CommentResidue.cs`

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `using System;`.

```text
One residue CommentEngine found in a file: the lines that stand where a comment block was moved to the file's
comment page — the insight line, any mechanical lines (citations and links only), and the docs-link line
`[comment:N](/<page>#commentN)` that closes it. Lines are 0-based and inclusive; the engine is pure over text
([ADR-AUTO-TYPES#9](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types9)).
```
