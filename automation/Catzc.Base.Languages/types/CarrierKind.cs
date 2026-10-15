// Where a file keeps its meta block: in its own text (front matter, comment head, ignored property), beside it (sidecar), or nowhere.
// ADR-REPO-FILEMETA#1 [comment:1](/docs/references/automation/catzc-base-languages/types/CarrierKind.cs.md#comment1)

namespace Catzc.Base.Languages;

public enum CarrierKind
{
    FrontMatter,
    CommentHead,
    Property,
    Sidecar,
    None,
}
