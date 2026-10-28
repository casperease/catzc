namespace Catzc.Base.Languages;

public enum CarrierKind
{
    FrontMatter,
    CommentHead,
    Property,
    // One fixed first line a language's own tools read, such as Go's "// Code generated ... DO NOT EDIT."; it holds no meta block.
    Banner,
    // A png's tEXt chunk keyed catzc, which only a writer's stamp fills.
    PngText,
    // An svg's <metadata> element, which only a writer's stamp fills.
    Metadata,
    // An xml file's <?catzc ...?> processing instruction, which only a writer's stamp fills.
    ProcessingInstruction,
    None,
}
