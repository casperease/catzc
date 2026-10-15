// How the link aligner treats a comment line that outgrows its line limit once a citation becomes a code link: Break continues the...
// [ADR-REPO-LINK#8](/docs/adr/repository/markdown-links.md#rule-adr-repo-link8)
// [comment:1](/docs/references/automation/catzc-base-qualitygates/types/LinkWrap.cs.md#comment1)

namespace Catzc.Base.QualityGates;

public enum LinkWrap
{
    Break,
    Off,
}
