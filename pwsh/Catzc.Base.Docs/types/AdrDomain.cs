/*
---
catzc:
  immutable:
    with_body_sha: "8f9a0da86289"
  edges:
    docs: "[AdrDomain.cs.md](docs/references/pwsh/catzc-base-docs/types/AdrDomain.cs.md)"
    cites:
      - ADR-BCL-TYPES-NATIVETYPEDMODEL
      - ADR-REPO-DRSCODE-DOMAINSEGMENT
      - DDR-TRACK-VALUECHAINSTACK
      - DDR-TRACK-VALUECHAINCONCERN
---
*/

using System.Collections.Generic;

namespace Catzc.Base.Docs;

public sealed class AdrDomain
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    public string Name { get; }
    // null under a kind the domain owns
    // ([ADR-REPO-DRSCODE-DOMAINSEGMENT](/docs/drs/repository/drs-code-language.md#rule-adr-repo-drscode-domainsegment))
    public string Code { get; }
    public string Kind { get; }                    // one of AdrsConfig.Kinds
    public string Prefix => Code == null ? Kind : Kind + "-" + Code; // the code every record of the domain starts with
    public string Role { get; }
    public string Description { get; }
    public IReadOnlyList<string> DependsOn { get; }
    public string Stack { get; }                  // one of AdrsConfig.Stacks
    public IReadOnlyList<string> Concerns { get; } // the domain default, one or more of AdrsConfig.Concerns
    public IReadOnlyList<AdrRuleSet> RuleSets { get; }
    public string Folder { get; }                  // the folder under docs/drs that holds the domain's ADRs

    public AdrDomain(string name, string code, string kind, string role, string description, IReadOnlyList<string> dependsOn, string stack, IReadOnlyList<string> concerns, IReadOnlyList<AdrRuleSet> ruleSets, string folder)
    {
        Name = name;
        Folder = folder;
        Code = code;
        Kind = kind;
        Role = role;
        Description = description;
        DependsOn = dependsOn;
        Stack = stack;
        Concerns = concerns;
        RuleSets = ruleSets;
    }
}
