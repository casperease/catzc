/*
---
catzc:
  immutable:
    path: automation/Catzc.Base.QualityGates/types/FileMetaDirection.cs
    folder: types
    name: file-meta-direction
    filetype: cs
    kind: type
    language: csharp
    track: automation
    tracktype: modules
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    page: docs/references/automation/catzc-base-qualitygates/types/FileMetaDirection.cs.md
    cites:
      - ADR-REPO-FILEMETA#2
---
*/

namespace Catzc.Base.QualityGates;

public enum FileMetaDirection
{
    Imprint,
    Gather,
}
