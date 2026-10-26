# pwsh/Base.Drs/types/DrsCitationRewrite.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
The result of rewriting one file's ADR references (DrsCitationRewriter.Rewrite): the new text and every change
made, in text order. Changed is false exactly when the text is the input unchanged, so a caller writes the file
only when it is true ([ADR-BCL-TYPES-NATIVETYPEDMODEL](/docs/drs/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-nativetypedmodel)).
```
