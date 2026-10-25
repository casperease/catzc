namespace Catzc.Base.QualityGates;

// The three ways one tracked file points at another (ADR-REPO-LINKS-EVERYLINKHASADIRECTION).
public enum LinkRelation
{
    MarkdownLink,
    CodeLink,
    DocsEdge,
}
