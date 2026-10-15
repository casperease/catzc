// catzc:
//   path: automation/Catzc.Base.Docs/types/AdrDomain.cs
//   module: Catzc.Base.Docs

// Built and validated only by AdrsConfig; Stack and Concerns are the domain defaults that a ruleset may override.
// [ADR-AUTO-TYPES#9](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types9),
// [ADR-DSGN-TRACK#14](/docs/adr/design/tracks.md#rule-adr-dsgn-track14),
// [ADR-DSGN-TRACK#15](/docs/adr/design/tracks.md#rule-adr-dsgn-track15)
// [comment:1](/docs/references/automation/catzc-base-docs/types/AdrDomain.cs.md#comment1)

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

    public AdrDomain(string name, string code, string role, string description, IReadOnlyList<string> dependsOn, string stack, IReadOnlyList<string> concerns, IReadOnlyList<AdrRuleSet> ruleSets)
    {
        Name = name;
        Code = code;
        Role = role;
        Description = description;
        DependsOn = dependsOn;
        Stack = stack;
        Concerns = concerns;
        RuleSets = ruleSets;
    }
}
