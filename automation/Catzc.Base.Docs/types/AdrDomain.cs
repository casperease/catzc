// One ADR domain (a docs/adr/<area>/ folder) from adrs.yml: its Name, 2-4 letter Code, Role, the DependsOn
// links that form the domain DAG, and the RuleSets it owns. Built and validated by AdrsConfig
// (docs/adr/automation/BCL/native-csharp-types.md, ADR-AUTO-TYPES:9).

using System.Collections.Generic;

namespace Catzc.Base.Docs;

public sealed class AdrDomain
{
    public string Name { get; }
    public string Code { get; }
    public string Role { get; }
    public IReadOnlyList<string> DependsOn { get; }
    public IReadOnlyList<AdrRuleSet> RuleSets { get; }

    public AdrDomain(string name, string code, string role, IReadOnlyList<string> dependsOn, IReadOnlyList<AdrRuleSet> ruleSets)
    {
        Name = name;
        Code = code;
        Role = role;
        DependsOn = dependsOn;
        RuleSets = ruleSets;
    }
}
