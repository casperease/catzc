/*
---
catzc:
  immutable:
    with_body_sha: "018cad8f6be3"
  edges:
    docs: "[DrsDomain.cs.md](../../../docs/references/pwsh/catzc-base-drs/types/DrsDomain.cs.md)"
    cites:
      - ADR-BCL-TYPES-NATIVETYPEDMODEL
      - ADR-REPO-DRSCODE-DOMAINSEGMENT
      - DDR-TRACK-VALUECHAINSTACK
      - DDR-TRACK-VALUECHAINCONCERN
---
*/

using System.Collections.Generic;

namespace Catzc.Base.Drs;

public sealed class DrsDomain
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    public string Name { get; }
    public string Code { get; }
    public string Kind { get; }                    // one of DrsConfig.Kinds
    public string Prefix => Code == null ? Kind : Kind + "-" + Code; // the code every record of the domain starts with
    public string Role { get; }
    public string Description { get; }
    public IReadOnlyList<string> DependsOn { get; }
    public string Stack { get; }                  // one of DrsConfig.Stacks
    public IReadOnlyList<string> Concerns { get; } // the domain default, one or more of DrsConfig.Concerns
    public IReadOnlyList<DrsRuleSet> RuleSets { get; }
    public string Folder { get; }                  // the folder under docs/drs that holds the domain's ADRs

    public DrsDomain(string name, string code, string kind, string role, string description, IReadOnlyList<string> dependsOn, string stack, IReadOnlyList<string> concerns, IReadOnlyList<DrsRuleSet> ruleSets, string folder)
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
