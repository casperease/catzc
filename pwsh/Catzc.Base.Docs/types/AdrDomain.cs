/*
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.Docs/types/AdrDomain.cs
    folder: types
    name: adr-domain
    filetype: cs
    role: type
    language: csharp
    track: pwsh
    tracktype: modules
    module: Catzc.Base.Docs
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    docs: "[AdrDomain.cs.md](docs/references/pwsh/catzc-base-docs/types/AdrDomain.cs.md)"
    cites:
      - ADR-AUTO-TYPES-NATIVETYPEDMODEL
      - ADR-DSGN-TRACK-VALUECHAINSTACK
      - ADR-DSGN-TRACK-VALUECHAINCONCERN
---
*/

using System.Collections.Generic;

namespace Catzc.Base.Docs;

public sealed class AdrDomain
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    public string Name { get; }
    public string Code { get; }
    public string Role { get; }
    public string Description { get; }
    public IReadOnlyList<string> DependsOn { get; }
    public string Stack { get; }                  // one of AdrsConfig.Stacks
    public IReadOnlyList<string> Concerns { get; } // the domain default, one or more of AdrsConfig.Concerns
    public IReadOnlyList<AdrRuleSet> RuleSets { get; }
    public string Folder { get; }                  // the folder under docs/adr that holds the domain's ADRs

    public AdrDomain(string name, string code, string role, string description, IReadOnlyList<string> dependsOn, string stack, IReadOnlyList<string> concerns, IReadOnlyList<AdrRuleSet> ruleSets, string folder)
    {
        Name = name;
        Folder = folder;
        Code = code;
        Role = role;
        Description = description;
        DependsOn = dependsOn;
        Stack = stack;
        Concerns = concerns;
        RuleSets = ruleSets;
    }
}
