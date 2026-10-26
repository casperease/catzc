namespace Catzc.Base.Languages;

public enum CarrierKind
{
    FrontMatter,
    CommentHead,
    Property,
    // One fixed first line a language's own tools read, such as Go's "// Code generated ... DO NOT EDIT."; it holds no meta block.
    Banner,
    None,
}
