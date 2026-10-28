using System;

namespace Catzc.Base.Drs;

// One edge of the domain dependency graph, From depends on To; the constructor holds both ends non-empty and distinct.
public sealed class DrsDomainEdge
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    public string From { get; }
    public string To { get; }

    public DrsDomainEdge(string from, string to)
    {
        if (string.IsNullOrWhiteSpace(from))
        {
            throw new ArgumentException("a DRS domain edge requires a non-empty 'From' domain");
        }
        if (string.IsNullOrWhiteSpace(to))
        {
            throw new ArgumentException(string.Format("DRS domain edge from '{0}' requires a non-empty 'To' domain", from));
        }
        if (string.Equals(from, to, StringComparison.Ordinal))
        {
            throw new ArgumentException(string.Format("DRS domain '{0}' cannot depend on itself", from));
        }

        From = from;
        To = to;
    }
}
