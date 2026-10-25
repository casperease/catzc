/*
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-quality-gates/types/LinkRelation.cs.md"
  warning: "Generated Header"
---
*/

namespace Catzc.Base.QualityGates;

public enum LinkRelation
{
    MarkdownLink,
    CodeLink,
    DocsEdge,
    // Implied by a declaration, never written in a file
    // ([ADR-REPO-LINKS-CONVENTIONSAREDERIVED](/docs/drs/repository/links-in-repository.md#rule-adr-repo-links-conventionsarederived)).
    Convention,
}
