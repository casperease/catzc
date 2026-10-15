# docs/references/automation/catzc-base-qualitygates/types/CommentFinding.cs.md

`automation/Catzc.Base.QualityGates/types/CommentFinding.cs`

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `using System;`.

```text
One finding of CommentFormatter: where (repository-relative file, 1-based line), what kind, a human message, and
whether Format-Comments fixes it. Every property is fixed at construction; the formatter is pure over text
([ADR-AUTO-TYPES#9](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types9)).
```
