/*
---
catzc:
  immutable:
    with_body_sha: "2a59f2cb5f16"
  edges:
    docs: "[AdrRuleSet.cs.md](docs/references/pwsh/catzc-base-docs/types/AdrRuleSet.cs.md)"
    cites:
      - ADR-AUTO-LAYERS-REALISENEVERREDEFINE
      - ADR-BCL-TYPES
      - ADR-DSGN-TRACK-VALUECHAINCONCERN
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
    public string Stack { get; }       // the owning domain's row of the value-chain stack
    public IReadOnlyList<string> Concerns { get; }       // effective value-chain concerns (override or domain default)
    public IReadOnlyList<string> DomainConcerns { get; } // the owning domain's default value-chain concerns
    public string Layer { get; }       // the layer of the automation the ADR belongs to ([ADR-AUTO-LAYERS-REALISENEVERREDEFINE](/docs/adr/automation/layers.md#rule-adr-auto-layers-realiseneverredefine))

    public string Folder { get; }      // the owning domain's folder under docs/adr

    public AdrRuleSet(string domain, string role, string slug, string external, string code, string domainCode, string stack, IReadOnlyList<string> concerns, IReadOnlyList<string> domainConcerns, string layer = AdrsConfig.DefaultLayer, string folder = null)
    {
        Layer = layer;
        Folder = folder ?? AdrsConfig.DefaultFolder(domain);
        Domain = domain;
        Role = role;
        Slug = slug;
        External = external;
        Code = code;
        DomainCode = domainCode;
        Stack = stack;
        Concerns = concerns;
        DomainConcerns = domainConcerns;
    }
}
