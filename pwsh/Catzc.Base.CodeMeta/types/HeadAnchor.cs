/*
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.CodeMeta/types/HeadAnchor.cs
    folder: types
    name: head-anchor
    filetype: cs
    role: type
    language: csharp
    track: pwsh
    tracktype: modules
    module: Catzc.Base.CodeMeta
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    docs: "[HeadAnchor.cs.md](docs/references/pwsh/catzc-base-codemeta/types/HeadAnchor.cs.md)"
    cites:
      - ADR-REPO-CODEMETA-CODEFILEHEAD
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
