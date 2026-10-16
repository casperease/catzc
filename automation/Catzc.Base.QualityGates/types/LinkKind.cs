/*
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/types/LinkKind.cs
    kind: type
    language: csharp
    filekind: cs
    track: automation
    module: Catzc.Base.QualityGates
    relatives:
      page: docs/references/automation/catzc-base-qualitygates/types/LinkKind.cs.md
    adrs:
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
