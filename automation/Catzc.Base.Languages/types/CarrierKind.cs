/*
---
catzc:
  derived:
    path: automation/Catzc.Base.Languages/types/CarrierKind.cs
    kind: type
    language: csharp
    filekind: cs
    track: automation
    module: Catzc.Base.Languages
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
