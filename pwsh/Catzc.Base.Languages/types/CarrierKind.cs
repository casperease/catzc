/*
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.Languages/types/CarrierKind.cs
    folder: types
    name: carrier-kind
    filetype: cs
    role: type
    language: csharp
    track: pwsh
    tracktype: modules
    module: Catzc.Base.Languages
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    docs: "[CarrierKind.cs.md](docs/references/pwsh/catzc-base-languages/types/CarrierKind.cs.md)"
    cites:
      - ADR-REPO-FILEMETA-HEADPOLICY
---
*/

namespace Catzc.Base.Languages;

public enum CarrierKind
{
    FrontMatter,
    CommentHead,
    Property,
    Sidecar,
    None,
}
