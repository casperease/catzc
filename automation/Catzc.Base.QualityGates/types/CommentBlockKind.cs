// The shapes of a comment block CommentEngine can move out of a file into its comment page
// ([ADR-PRIN-ONELIVE#1](/docs/adr/principles/one-living-version.md#rule-adr-prin-onelive1)):
//   LineRun     consecutive own-line comments with one marker and indent (`# …`, `// …`, `/// …`)
//   Block       one delimited comment (`<# … #>`, `/* … */`) that is not comment-based help
//   HelpSection the body of one `.KEYWORD` section inside a PowerShell comment-based help block

namespace Catzc.Base.QualityGates;

public enum CommentBlockKind
{
    LineRun,
    Block,
    HelpSection,
}
