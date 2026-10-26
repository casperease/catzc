/*
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-quality-gates/types/FileMetaDirection.cs.md"
  header: "generated"
---
*/

namespace Catzc.Base.QualityGates;

// Imprint writes derived facts into a meta block; gather reads config contributions out of it.
public enum FileMetaDirection
{
    Imprint,
    Gather,
}
