// Imprint writes derived facts into a file's meta block; gather reads config contributions out of it
// ([ADR-REPO-MDMETA#2](/docs/adr/repository/markdown-meta.md#rule-adr-repo-mdmeta2)).
// [ADR-REPO-MDMETA#2](/docs/adr/repository/markdown-meta.md#rule-adr-repo-mdmeta2)

namespace Catzc.Base.QualityGates;

public enum MarkdownMetaDirection
{
    Imprint,
    Gather,
}
