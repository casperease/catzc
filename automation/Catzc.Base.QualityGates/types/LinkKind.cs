/*
---
catzc:
  immutable:
    path: automation/Catzc.Base.QualityGates/types/LinkKind.cs
    folder: types
    name: link-kind
    filetype: cs
    kind: type
    language: csharp
    track: automation
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    page: docs/references/automation/catzc-base-qualitygates/types/LinkKind.cs.md
    cites:
      - ADR-REPO-LINK#1
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
