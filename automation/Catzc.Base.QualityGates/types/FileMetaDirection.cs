// Imprint writes derived facts into a file's meta block; gather reads config contributions out of it.
// [ADR-REPO-FILEMETA#2](/docs/adr/repository/file-meta.md#rule-adr-repo-filemeta2)
// [comment:1](/docs/references/automation/catzc-base-qualitygates/types/FileMetaDirection.cs.md#comment1)

namespace Catzc.Base.QualityGates;

public enum FileMetaDirection
{
    Imprint,
    Gather,
}
