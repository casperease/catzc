/*
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/types/LinkWrap.cs
    kind: type
    module: Catzc.Base.QualityGates
    adrs:
      - ADR-REPO-LINK#8
---
*/

// Break never splits inside a link, it continues the comment before the link; Off leaves the line long and reports it.
// [comment:1](/docs/references/automation/catzc-base-qualitygates/types/LinkWrap.cs.md#comment1)

namespace Catzc.Base.QualityGates;

public enum LinkWrap
{
    Break,
    Off,
}
