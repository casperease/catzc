# pwsh/Base.Drs/types/DrsCitationRewrite.cs

The result of rewriting one file's record references (`DrsCitationRewriter.Rewrite`): the new text and every change made, in text order
([ADR-BCL-TYPES-NATIVETYPEDMODEL](../../../../drs/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-nativetypedmodel)).

## Changed

`Changed` is false exactly when the text is the input unchanged, so a caller writes the file only when it is true.
