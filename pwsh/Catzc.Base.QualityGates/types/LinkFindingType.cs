/*
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-quality-gates/types/LinkFindingType.cs.md"
  warning: "Generated Header"
---
*/

namespace Catzc.Base.QualityGates;

public enum LinkFindingType
{
    // Code kind — fixable.
    Bare,           // a bare docs/drs path in a comment becomes a code link
    Relative,       // a ../ or rooted-but-unlinked path becomes a code link
    SlugOnly,       // an ADR file name alone (`caching.md`) becomes a code link when the slug is unique
    Adjacent,       // a path immediately followed by its own citation merges into one code link
    Citation,       // a bare citation code in a comment becomes a code link
    Stale,          // a path to a moved ADR is re-pointed from its citation code or unique file name
    TextMismatch,   // a code link whose destination disagrees with its citation text; the code wins
    NonCanonical,   // a code link in another shape (relative destination, slug text) is re-spelled canonically

    // Markdown kind — fixable.
    Rooted,         // a repository-rooted link in a .md file becomes relative to the file

    // Not fixable.
    Dangling,       // the link target does not exist
    Untracked,      // a markdown link target exists on disk but git does not track it, so GitHub cannot resolve it
    UnknownCode,    // the citation code is not in the ADR index
    UnknownRule,    // the ADR declares no such rule
    Numbered,       // a numbered citation (`ADR-X:n`, `ADR-X#n`) where a rule is cited by its name
    StringNumbered, // a numbered citation in a string literal; the string_citations setting decides whether it fails the gate
    BadAnchor,      // the #fragment names no heading or anchor of the target
    EscapesRoot,    // a relative link climbs above the repository root
    SelfUrl,        // an absolute URL into this repository outside .github/
    StringPathMissing, // a docs path in a string literal names no file

    // Informational.
    Overlong,
}
