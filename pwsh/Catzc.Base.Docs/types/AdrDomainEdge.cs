/*
---
catzc:
  immutable:
    with_body_sha: "5099d55ae51a"
  edges:
    test: pwsh/Catzc.Base.Docs/tests/types/AdrDomainEdge.Tests.ps1
    docs: "[AdrDomainEdge.cs.md](docs/references/pwsh/catzc-base-docs/types/AdrDomainEdge.cs.md)"
    cites:
      - ADR-BCL-TYPES-NATIVETYPEDMODEL
---
*/

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
