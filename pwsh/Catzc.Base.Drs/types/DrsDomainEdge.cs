/*
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-drs/types/DrsDomainEdge.cs.md"
  header: "generated"
---
*/

using System;

namespace Catzc.Base.Drs;

public sealed class DrsDomainEdge
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    public string From { get; }
    public string To { get; }

    public DrsDomainEdge(string from, string to)
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
