/*
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.QualityGates/types/FileMetaDirection.cs
    folder: types
    name: file-meta-direction
    filetype: cs
    role: type
    language: csharp
    track: pwsh
    tracktype: modules
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    docs: "[FileMetaDirection.cs.md](docs/references/pwsh/catzc-base-qualitygates/types/FileMetaDirection.cs.md)"
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
