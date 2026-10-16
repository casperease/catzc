/*
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/types/LinkWrap.cs
    folder: types
    name: link-wrap
    filetype: cs
    kind: type
    language: csharp
    track: automation
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
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
