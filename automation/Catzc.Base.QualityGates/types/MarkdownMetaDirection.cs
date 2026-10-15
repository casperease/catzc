// Imprint writes derived facts into a file's meta block; gather reads config contributions out of it
// ([ADR-REPO-FILEMETA#2](/docs/adr/repository/file-meta.md#rule-adr-repo-filemeta2)).
// [ADR-REPO-FILEMETA#2](/docs/adr/repository/file-meta.md#rule-adr-repo-filemeta2)

namespace Catzc.Base.QualityGates;

public enum MarkdownMetaDirection
{
    Imprint,
    Gather,
}
