// One ADR domain (a docs/adr/<area>/ folder) from adrs.yml: its Name, 2-4 letter Code, Role, the reader-facing
// Description rendered under the domain's heading in the generated index, the DependsOn links that form the
// domain DAG, and the RuleSets it owns. Built and validated by AdrsConfig
// ([ADR-AUTO-TYPES#9](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types9)).

using System.Collections.Generic;

namespace Catzc.Base.Docs;

public sealed class AdrDomain
{
    public string Name { get; }
    public string Code { get; }
    public string Role { get; }
    public string Description { get; }
    public IReadOnlyList<string> DependsOn { get; }
    public IReadOnlyList<AdrRuleSet> RuleSets { get; }

    public AdrDomain(string name, string code, string role, string description, IReadOnlyList<string> dependsOn, IReadOnlyList<AdrRuleSet> ruleSets)
    {
        Name = name;
        Code = code;
        Role = role;
        Description = description;
        DependsOn = dependsOn;
        RuleSets = ruleSets;
    }
}
