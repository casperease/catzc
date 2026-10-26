/*
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-quality-gates/types/LinkRelation.cs.md"
  header: "generated"
---
*/

namespace Catzc.Base.QualityGates;

// The three ways one tracked file points at another.
public enum LinkRelation
{
    MarkdownLink,
    CodeLink,
    DocsEdge,
    // Implied by a declaration and never written in a file, so no file's text can carry or lose it.
    Convention,
}
