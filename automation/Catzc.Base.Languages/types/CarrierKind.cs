/*
---
catzc:
  derived:
    path: automation/Catzc.Base.Languages/types/CarrierKind.cs
    folder: types
    name: carrier-kind
    filetype: cs
    kind: type
    language: csharp
    track: automation
    module: Catzc.Base.Languages
    moduletype: pwsh-folder
    catzc_bundle: azure
    relatives:
      page: docs/references/automation/catzc-base-languages/types/CarrierKind.cs.md
    adrs:
      - ADR-REPO-FILEMETA#1
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
