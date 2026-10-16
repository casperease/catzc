/*
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/types/FileMetaDirection.cs
    kind: type
    language: csharp
    filetype: cs
    track: automation
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder-module
    bundle: azure
    relatives:
      page: docs/references/automation/catzc-base-qualitygates/types/FileMetaDirection.cs.md
    adrs:
      - ADR-REPO-FILEMETA#2
---
*/

namespace Catzc.Base.QualityGates;

public enum FileMetaDirection
{
    Imprint,
    Gather,
}
