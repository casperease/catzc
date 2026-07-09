// One ADR rule-set (an ADR) as declared in adrs.yml: its internal kebab Slug, full External citation code
// (ADR-<DC>-<NAME>), the effective domain Code (a leaf override, else the domain default DomainCode), the
// folder-owning Domain and its Role, and the optional Terminology token. A processed record built and
// validated by AdrsConfig — not a raw YAML mirror, so PascalCase (docs/adr/automation/BCL/native-csharp-types.md,
// ADR-AUTO-TYPES:9). See the ADR domain-wiring plan.

namespace Catzc.Base.Docs;

public sealed class AdrRuleSet
{
    public string Domain { get; }
    public string Role { get; }
    public string Slug { get; }
    public string External { get; }
    public string Code { get; }        // effective domain code (leaf override or domain default)
    public string DomainCode { get; }  // the folder-owning domain's default code
    public string Terminology { get; } // registered adr: spelling token, or null

    public AdrRuleSet(string domain, string role, string slug, string external, string code, string domainCode, string terminology)
    {
        Domain = domain;
        Role = role;
        Slug = slug;
        External = external;
        Code = code;
        DomainCode = domainCode;
        Terminology = terminology;
    }
}
