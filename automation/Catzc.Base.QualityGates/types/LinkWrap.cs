/*
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/types/LinkWrap.cs
    kind: type
    language: csharp
    filetype: cs
    track: automation
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder-module
    bundle: azure
    relatives:
      page: docs/references/automation/catzc-base-qualitygates/types/LinkWrap.cs.md
    adrs:
      - ADR-REPO-LINK#8
---
*/

namespace Catzc.Base.QualityGates;

public enum LinkWrap
{
    Break,
    Off,
}
