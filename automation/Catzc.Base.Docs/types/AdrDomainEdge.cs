// One edge of the ADR domain dependency graph from adrs.yml: From depends on To (one per declared depends_on
// link). Built by AdrsConfig from its already-validated domains and exposed as AdrsConfig.Edges; the constructor
// holds the edge's own invariant — both ends non-empty and distinct (no self-edge)
// ([ADR-AUTO-TYPES#9](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types9)).

using System;

namespace Catzc.Base.Docs;

public sealed class AdrDomainEdge
{
    public string From { get; }
    public string To { get; }

    public AdrDomainEdge(string from, string to)
    {
        if (string.IsNullOrWhiteSpace(from))
        {
            throw new ArgumentException("an ADR domain edge requires a non-empty 'From' domain");
        }
        if (string.IsNullOrWhiteSpace(to))
        {
            throw new ArgumentException(string.Format("ADR domain edge from '{0}' requires a non-empty 'To' domain", from));
        }
        if (string.Equals(from, to, StringComparison.Ordinal))
        {
            throw new ArgumentException(string.Format("ADR domain '{0}' cannot depend on itself", from));
        }

        From = from;
        To = to;
    }
}
