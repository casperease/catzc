/*
---
catzc:
  derived:
    path: automation/Catzc.Base.Docs/types/AdrDomainEdge.cs
    kind: type
    module: Catzc.Base.Docs
---
*/

// The constructor guards the edge invariant: both ends non-empty and distinct, so no domain depends on itself.
// [ADR-AUTO-TYPES#9](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types9)
// [comment:1](/docs/references/automation/catzc-base-docs/types/AdrDomainEdge.cs.md#comment1)

using System;

namespace Catzc.Base.Docs;

public sealed class AdrDomainEdge
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

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
