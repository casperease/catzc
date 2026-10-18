// A run of line comments, or one delimited block; both move to the page the same way.

namespace Catzc.Base.QualityGates;

// Rests on [ADR-PRIN-ONELIVE#1](/docs/adr/principles/one-living-version.md#rule-adr-prin-onelive1).
public enum CommentBlockKind
{
    LineRun,
    Block,
}
