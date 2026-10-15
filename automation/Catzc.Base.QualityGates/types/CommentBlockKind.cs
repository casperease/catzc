/*
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/types/CommentBlockKind.cs
    kind: type
    module: Catzc.Base.QualityGates
---
*/

// Block excludes comment-based help, whose keyword sections are split out as HelpSection instead.
// [ADR-PRIN-ONELIVE#1](/docs/adr/principles/one-living-version.md#rule-adr-prin-onelive1)
// [comment:1](/docs/references/automation/catzc-base-qualitygates/types/CommentBlockKind.cs.md#comment1)

namespace Catzc.Base.QualityGates;

public enum CommentBlockKind
{
    LineRun,
    Block,
    HelpSection,
}
