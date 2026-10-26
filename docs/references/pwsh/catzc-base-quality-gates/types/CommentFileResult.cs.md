# pwsh/Base.QualityGates/types/CommentFileResult.cs

What `CommentEngine.Export` decided for one file: the file's new text and its page's new text, each null when nothing changes, and the
blocks it moved. The engine never writes; the caller does, so the result is a native typed model
([ADR-BCL-TYPES-NATIVETYPEDMODEL](../../../../drs/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-nativetypedmodel)).
