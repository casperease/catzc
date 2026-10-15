// catzc:
//   path: automation/Catzc.Base.QualityGates/types/LinkWrap.cs
//   module: Catzc.Base.QualityGates

// Break never splits inside a link, it continues the comment before the link; Off leaves the line long and reports it.
// [ADR-REPO-LINK#8](/docs/adr/repository/markdown-links.md#rule-adr-repo-link8)
// [comment:1](/docs/references/automation/catzc-base-qualitygates/types/LinkWrap.cs.md#comment1)

namespace Catzc.Base.QualityGates;

public enum LinkWrap
{
    Break,
    Off,
}
