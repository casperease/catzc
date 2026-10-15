/*
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/types/CommentFindingKind.cs
    kind: csharp-type
    module: Catzc.Base.QualityGates
    adrs:
      - ADR-PRIN-ONELIVE#1
---
*/

// Fixable kinds are rewritten by Format-Comments; the rest need a person, or Export-Comments, to resolve.
// [comment:1](/docs/references/automation/catzc-base-qualitygates/types/CommentFindingKind.cs.md#comment1)

namespace Catzc.Base.QualityGates;

public enum CommentFindingKind
{
    // Fixable.
    Empty,          // no insight line above the docs link: the provisional one is cut from the comment's own section
    LinkInInsight,  // the insight line carries a link or a citation: both go, the head lists the file's citations
    Overlong,       // the insight line is over the file's line limit: cut at a word, first sentence only
    CitationInResidue, // a citation line below the insight, or citations before the docs link: they go, the head lists them
    LinkInHelp,     // a docs link in a help section its page names uniquely: it goes, the page pairs the section by name

    // Not fixable.
    Obvious,        // the insight line starts with one of comments.yml's obvious phrases: a person writes the insight
    ProseOnLinkLine, // the docs-link line carries more than citations, links and separators
    MissingSection, // no insight line, and the page holds no section for the residue to cut one from
    LongComment,    // a comment that Export-Comments would move still lives in the file
}
