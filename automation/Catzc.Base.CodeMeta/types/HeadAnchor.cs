/*
---
catzc:
  derived:
    path: automation/Catzc.Base.CodeMeta/types/HeadAnchor.cs
    folder: types
    name: head-anchor
    filetype: cs
    kind: type
    language: csharp
    track: automation
    module: Catzc.Base.CodeMeta
    moduletype: pwsh-folder
    catzc_bundle: azure
    relatives:
      page: docs/references/automation/catzc-base-codemeta/types/HeadAnchor.cs.md
    adrs:
      - ADR-REPO-CODEMETA#1
---
*/

namespace Catzc.Base.CodeMeta;

public enum HeadAnchor
{
    Start,
    AfterShebang,
    AfterProlog,
    AfterPreamble,
}
