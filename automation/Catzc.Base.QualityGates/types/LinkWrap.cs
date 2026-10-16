/*
---
catzc:
  immutable:
    path: automation/Catzc.Base.QualityGates/types/LinkWrap.cs
    folder: types
    name: link-wrap
    filetype: cs
    kind: type
    language: csharp
    track: automation
    tracktype: modules
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    page: docs/references/automation/catzc-base-qualitygates/types/LinkWrap.cs.md
    cites:
      - ADR-REPO-LINK#8
---
*/

namespace Catzc.Base.QualityGates;

public enum LinkWrap
{
    Break,
    Off,
}
