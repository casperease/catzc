/*
---
catzc:
  immutable:
    with_body_sha: "7be0112e5b43"
  edges:
    docs: "[FileMetaDirection.cs.md](../../../docs/references/pwsh/catzc-base-quality-gates/types/FileMetaDirection.cs.md)"
    cites:
      - ADR-REPO-FILEMETA-METAKIND
---
*/

namespace Catzc.Base.QualityGates;

public enum FileMetaDirection
{
    Imprint,
    Gather,
}
