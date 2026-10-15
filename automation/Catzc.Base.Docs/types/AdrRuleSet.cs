// One ADR rule-set (an ADR) as declared in adrs.yml: its internal kebab Slug, full External citation code (ADR-<DC>-<NAME>), the...
// [ADR-AUTO-TYPES](/docs/adr/automation/BCL/native-csharp-types.md),
// [ADR-AUTO-TYPES#9](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types9),
// [ADR-DSGN-TRACK#15](/docs/adr/design/tracks.md#rule-adr-dsgn-track15)
// [comment:1](/docs/references/automation/catzc-base-docs/types/AdrRuleSet.cs.md#comment1)

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
