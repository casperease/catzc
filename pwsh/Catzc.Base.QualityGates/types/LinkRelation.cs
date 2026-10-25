namespace Catzc.Base.QualityGates;

// The three ways one tracked file points at another
// ([ADR-REPO-LINKS-EVERYLINKHASADIRECTION](/docs/drs/repository/links-in-repository.md#rule-adr-repo-links-everylinkhasadirection)).
public enum LinkRelation
{
    MarkdownLink,
    CodeLink,
    DocsEdge,
}
