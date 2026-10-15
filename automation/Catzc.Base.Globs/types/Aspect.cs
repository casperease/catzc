// catzc:
//   path: automation/Catzc.Base.Globs/types/Aspect.cs
//   module: Catzc.Base.Globs

// The last aspect is the non-live catch-all, so a file live does not explicitly claim can never silently ship.
// [ADR-DSGN-ASPECT](/docs/adr/design/module-aspects.md), [ADR-FLOW-CD-GLOBS#4](/docs/adr/flow/durable-sha-globs.md#rule-adr-flow-cd-globs4)
// [comment:1](/docs/references/automation/catzc-base-globs/types/Aspect.cs.md#comment1)

using System;
using System.Collections.Generic;
using System.Text.RegularExpressions;

namespace Catzc.Base.Globs;

public sealed class Aspect
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    private static readonly Regex KebabCase = new Regex("^[a-z][a-z0-9]*(-[a-z0-9]+)*$");

    public string Name { get; }
    public IReadOnlyList<string> Patterns { get; }   // relative to the unit root

    public Aspect(string name, string[] patterns)
    {
        if (string.IsNullOrWhiteSpace(name) || !KebabCase.IsMatch(name))
        {
            throw new ArgumentException(string.Format("aspect name '{0}' must be kebab-case", name));
        }
        if (patterns == null || patterns.Length == 0)
        {
            throw new ArgumentException(string.Format("aspect '{0}' needs at least one pattern", name));
        }
        Name = name;
        Patterns = (string[])patterns.Clone();
    }
}

// The exclude set is what turns first-match order into a disjoint slice; PowerShell builds the GlobSet from these.
// [comment:2](/docs/references/automation/catzc-base-globs/types/Aspect.cs.md#comment2)
public sealed class CompiledAspect
{
    public string Name { get; }
    public string[] Include { get; }
    public string[] Exclude { get; }

    public CompiledAspect(string name, string[] include, string[] exclude)
    {
        Name = name;
        Include = include;
        Exclude = exclude;
    }
}

public static class AspectPartition
{
    // Each aspect excludes every earlier aspect's patterns, so the last catch-all becomes the remainder under the root.
    // [comment:3](/docs/references/automation/catzc-base-globs/types/Aspect.cs.md#comment3)
    public static IReadOnlyList<CompiledAspect> Compile(IReadOnlyList<Aspect> aspects, string unitRoot)
    {
        if (aspects == null || aspects.Count == 0)
        {
            throw new ArgumentException("an aspect partition needs at least one aspect");
        }
        string root = (unitRoot ?? string.Empty).TrimEnd('/');
        List<CompiledAspect> compiled = new List<CompiledAspect>();
        List<string> earlier = new List<string>();
        foreach (Aspect aspect in aspects)
        {
            List<string> include = new List<string>();
            foreach (string pattern in aspect.Patterns) { include.Add(Prefix(root, pattern)); }
            compiled.Add(new CompiledAspect(aspect.Name, include.ToArray(), earlier.ToArray()));
            earlier.AddRange(include);
        }
        return compiled;
    }

    private static string Prefix(string root, string pattern)
    {
        return root.Length == 0 ? pattern : root + "/" + pattern;
    }

    // A file claimed by two aspects breaks disjointness, and one claimed by none breaks exhaustiveness.
    // [ADR-DSGN-ASPECT#5](/docs/adr/design/module-aspects.md#rule-adr-dsgn-aspect5)
    // [comment:4](/docs/references/automation/catzc-base-globs/types/Aspect.cs.md#comment4)
    public static IReadOnlyList<string> Validate(IReadOnlyList<GlobSet> aspectSets, IEnumerable<string> universe)
    {
        List<string> violations = new List<string>();
        foreach (string file in universe)
        {
            List<string> owners = new List<string>();
            foreach (GlobSet set in aspectSets)
            {
                if (set.Matches(file)) { owners.Add(set.Name); }
            }
            if (owners.Count == 0)
            {
                violations.Add(string.Format("'{0}' is claimed by no aspect (exhaustive violated)", file));
            }
            else if (owners.Count > 1)
            {
                violations.Add(string.Format("'{0}' is claimed by {1} aspects: {2} (disjoint violated)", file, owners.Count, string.Join(", ", owners)));
            }
        }
        return violations;
    }
}
