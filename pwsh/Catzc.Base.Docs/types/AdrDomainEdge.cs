/*
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.Docs/types/AdrDomainEdge.cs
    folder: types
    name: adr-domain-edge
    filetype: cs
    role: type
    language: csharp
    track: pwsh
    tracktype: modules
    module: Catzc.Base.Docs
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    test: pwsh/Catzc.Base.Docs/tests/types/AdrDomainEdge.Tests.ps1
    docs: "[AdrDomainEdge.cs.md](docs/references/pwsh/catzc-base-docs/types/AdrDomainEdge.cs.md)"
    cites:
      - ADR-AUTO-TYPES-NATIVETYPEDMODEL
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
