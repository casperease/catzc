// What CommentFormatter found at one residue of a file, or at one comment that still lives there.
// [ADR-PRIN-ONELIVE#1](/docs/adr/principles/one-living-version.md#rule-adr-prin-onelive1)
// [comment:1](/docs/references/automation/catzc-base-qualitygates/types/CommentFindingKind.cs.md#comment1)

namespace Catzc.Base.QualityGates;

public enum CommentFindingKind
{
    // Fixable.
    Empty,          // no insight line above the docs link: the provisional one is cut from the comment's own section
    LinkInInsight,  // the insight line carries a link or a citation: links go, citations move to the docs-link line
    Overlong,       // the insight line is over the file's line limit: cut at a word, first sentence only

    // Not fixable.
    Obvious,        // the insight line starts with one of comments.yml's obvious phrases: a person writes the insight
    ProseOnLinkLine, // the docs-link line carries more than citations, links and separators
    MissingSection, // no insight line, and the page holds no section for the residue to cut one from
    LongComment,    // a comment that Export-Comments would move still lives in the file
}
