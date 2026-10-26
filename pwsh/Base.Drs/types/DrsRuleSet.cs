/*
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-drs/types/DrsRuleSet.cs.md"
  header: "generated"
---
*/

using System.Collections.Generic;

namespace Catzc.Base.Drs;

// One rule set, a record as drs.yml declares it: slug, external code, effective domain code, owning domain and its role.
public sealed class DrsRuleSet
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    public string Domain { get; }
    public string Role { get; }
    public string Slug { get; }
    public string External { get; }
    public string Code { get; }        // effective domain code (leaf override or domain default); null under a kind one domain owns
    public string Kind => External.Substring(0, External.IndexOf('-') < 0 ? External.Length : External.IndexOf('-'));
    public string Prefix => Code == null ? Kind : Kind + "-" + Code; // the code every rule of the ruleset starts with
    public string DomainCode { get; }  // the folder-owning domain's default code
    public string Stack { get; }       // the owning domain's row of the value-chain stack
    public IReadOnlyList<string> Concerns { get; }       // effective value-chain concerns (override or domain default)
    public IReadOnlyList<string> DomainConcerns { get; } // the owning domain's default value-chain concerns
    public string Layer { get; }       // the layer of the automation the ADR belongs to ([ADR-AUTO-LAYERS-REALISENEVERREDEFINE](/docs/drs/automation/layers.md#rule-adr-auto-layers-realiseneverredefine))

    public string Folder { get; }      // the owning domain's folder under docs/drs

    public DrsRuleSet(string domain, string role, string slug, string external, string code, string domainCode, string stack, IReadOnlyList<string> concerns, IReadOnlyList<string> domainConcerns, string layer = DrsConfig.DefaultLayer, string folder = null)
    {
        Layer = layer;
        Folder = folder ?? DrsConfig.DefaultFolder(domain);
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
