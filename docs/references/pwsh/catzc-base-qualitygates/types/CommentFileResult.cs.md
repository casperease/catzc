# pwsh/Catzc.Base.QualityGates/types/CommentFileResult.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
What CommentEngine.Export decided for one file: the file's new text and its page's new text (each null when
nothing changes), and the blocks it moved. The engine never writes; the caller does
([ADR-BCL-TYPES-NATIVETYPEDMODEL](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-nativetypedmodel)).
```
