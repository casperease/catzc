// How the link aligner treats a comment line that outgrows its line limit once a citation becomes a code link
// ([ADR-REPO-LINK#8](/docs/adr/repository/markdown-links.md#rule-adr-repo-link8)): Break continues the comment on a new line before the
// link (never inside it), with the same
// comment prefix and indent; Off leaves the line long and reports it. Configured in links.yml.

namespace Catzc.Base.QualityGates;

public enum LinkWrap
{
    Break,
    Off,
}
