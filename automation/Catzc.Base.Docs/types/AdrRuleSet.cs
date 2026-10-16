/*
---
catzc:
  derived:
    path: automation/Catzc.Base.Docs/types/AdrRuleSet.cs
    kind: type
    language: csharp
    filekind: cs
    track: automation
    module: Catzc.Base.Docs
    relatives:
      page: docs/references/automation/catzc-base-docs/types/AdrRuleSet.cs.md
    adrs:
      - ADR-AUTO-TYPES
      - ADR-DSGN-TRACK#15
---
*/

using System.Collections.Generic;

namespace Catzc.Base.Docs;

public sealed class AdrRuleSet
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    public string Domain { get; }
    public string Role { get; }
    public string Slug { get; }
    public string External { get; }
    public string Code { get; }        // effective domain code (leaf override or domain default)
    public string DomainCode { get; }  // the folder-owning domain's default code
    public string Terminology { get; } // registered adr: spelling token, or null
    public string Stack { get; }       // the owning domain's row of the value-chain stack
    public IReadOnlyList<string> Concerns { get; }       // effective value-chain concerns (override or domain default)
    public IReadOnlyList<string> DomainConcerns { get; } // the owning domain's default value-chain concerns

    public AdrRuleSet(string domain, string role, string slug, string external, string code, string domainCode, string terminology, string stack, IReadOnlyList<string> concerns, IReadOnlyList<string> domainConcerns)
    {
        Domain = domain;
        Role = role;
        Slug = slug;
        External = external;
        Code = code;
        DomainCode = domainCode;
        Terminology = terminology;
        Stack = stack;
        Concerns = concerns;
        DomainConcerns = domainConcerns;
    }
}
