/*
---
catzc:
  derived:
    path: automation/Catzc.Base.CodeMeta/types/HeadAnchor.cs
    kind: type
    language: csharp
    filekind: cs
    track: automation
    module: Catzc.Base.CodeMeta
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
