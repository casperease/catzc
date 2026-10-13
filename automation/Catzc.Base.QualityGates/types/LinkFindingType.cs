// What the link engine found at one place in a file
// ([ADR-REPO-LINK](/docs/adr/repository/markdown-links.md)). The fixable types are rewritten by
// Format-Links and reported by Test-Links until they are; the rest cannot be fixed mechanically and need a
// person. Overlong is informational: a line that stays over its limit after the aligner did what it can.

namespace Catzc.Base.QualityGates;

public enum LinkFindingType
{
    // Code kind — fixable.
    Bare,           // a bare docs/adr path in a comment becomes a code link
    Relative,       // a ../ or rooted-but-unlinked path becomes a code link
    SlugOnly,       // an ADR file name alone
                    // ([ADR-AUTO-CACHE](/docs/adr/automation/caching.md)) becomes a code link when the slug is unique
    Adjacent,       // a path immediately followed by its own citation merges into one code link
    Citation,       // a bare citation code in a comment becomes a code link
    Stale,          // a path to a moved ADR is re-pointed from its citation code or unique file name
    TextMismatch,   // a code link whose destination disagrees with its citation text; the code wins
    NonCanonical,   // a code link in another shape (relative destination, slug text) is re-spelled canonically

    // Both kinds — fixable.
    Colon,          // `ADR-X:n` becomes `ADR-X#n` outside the rule's own heading

    // Markdown kind — fixable.
    Rooted,         // a repository-rooted link in a .md file becomes relative to the file

    // Not fixable.
    Dangling,       // the link target does not exist
    UnknownCode,    // the citation code is not in the ADR index
    UnknownRule,    // the ADR declares no such rule
    BadAnchor,      // the #fragment names no heading or anchor of the target
    EscapesRoot,    // a relative link climbs above the repository root
    SelfUrl,        // an absolute URL into this repository outside .github/
    StringPathMissing, // a docs path in a string literal names no file

    // Informational.
    Overlong,
}
