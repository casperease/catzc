/*
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/types/FileMetaDirection.cs
    kind: type
    module: Catzc.Base.QualityGates
    adrs:
      - ADR-REPO-FILEMETA#2
---
*/

// Imprint writes derived facts into a file's meta block; gather reads config contributions out of it.
// [comment:1](/docs/references/automation/catzc-base-qualitygates/types/FileMetaDirection.cs.md#comment1)

namespace Catzc.Base.QualityGates;

public enum FileMetaDirection
{
    Imprint,
    Gather,
}
