// The shapes of a comment block CommentEngine can move out of a file into its comment page: LineRun consecutive own-line comments with...
// [ADR-PRIN-ONELIVE#1](/docs/adr/principles/one-living-version.md#rule-adr-prin-onelive1)
// [comment:1](/docs/references/automation/catzc-base-qualitygates/types/CommentBlockKind.cs.md#comment1)

namespace Catzc.Base.QualityGates;

public enum CommentBlockKind
{
    LineRun,
    Block,
    HelpSection,
}
