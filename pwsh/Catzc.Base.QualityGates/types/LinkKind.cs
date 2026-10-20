/*
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.QualityGates/types/LinkKind.cs
    folder: types
    name: link-kind
    filetype: cs
    role: type
    language: csharp
    track: pwsh
    tracktype: modules
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    docs: "[LinkKind.cs.md](docs/references/pwsh/catzc-base-qualitygates/types/LinkKind.cs.md)"
    cites:
      - ADR-REPO-LINK-KINDBYFILE
---
*/

using System;

namespace Catzc.Base.QualityGates;

[Flags]
public enum LinkKind
{
    Code = 1,
    Markdown = 2,
    Both = Code | Markdown,
}
