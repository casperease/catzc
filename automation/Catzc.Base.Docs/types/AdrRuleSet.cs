/*
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.Docs/types/AdrRuleSet.cs
    folder: types
    name: adr-rule-set
    filetype: cs
    kind: type
    language: csharp
    track: automation
    tracktype: modules
    module: Catzc.Base.Docs
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    page: docs/references/automation/catzc-base-docs/types/AdrRuleSet.cs.md
    cites:
      - ADR-AUTO-LAYERS#6
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
    public string Layer { get; }       // the layer of the automation the ADR belongs to ([ADR-AUTO-LAYERS#6](/docs/adr/automation/layers.md#rule-adr-auto-layers6))

    public AdrRuleSet(string domain, string role, string slug, string external, string code, string domainCode, string terminology, string stack, IReadOnlyList<string> concerns, IReadOnlyList<string> domainConcerns, string layer = AdrsConfig.DefaultLayer)
    {
        Layer = layer;
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
