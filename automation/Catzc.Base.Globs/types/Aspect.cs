// Aspects (ADR-ASPECT): a unit's tracked files partition into named facets — pairwise DISJOINT and jointly
// EXHAUSTIVE. The aspect set is the ordered first-match ('fallthrough') classification carried by the
// 'aspects' variant (Catzc.Base.Variants): each aspect claims by its patterns, the LAST aspect is the '**'
// catch-all remainder and by rule is non-live, so anything 'live' does not explicitly claim falls to the
// verification side and can never silently ship.
//
// Compilation onto a unit root reuses the leaf scan program (ADR-GLOBS:4): aspect k becomes a GlobSet with
// Include = k's own patterns and Exclude = every EARLIER aspect's patterns (all prefixed by the unit root).
// A leaf program is '+ includes' then '- excludes', last-match-wins — which is exactly first-match slicing:
// a file is in aspect k iff it matches k's patterns and no earlier aspect's. Disjoint + exhaustive hold by
// construction; AspectPartition.Validate re-checks against a real file universe for the integrity gate.
// See docs/adr/design/module-aspects.md.

using System;
using System.Collections.Generic;
using System.Text.RegularExpressions;

namespace Catzc.Base.Globs;

public sealed class Aspect
{
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

// One aspect compiled onto a unit root: the name plus the leaf (include, exclude) rule sets that encode its
// first-match slice. PowerShell (Get-ModuleAspect) builds the GlobSet from these.
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
    // Compile the ordered aspect convention onto a unit root (e.g. "automation/Catzc.Base.Globs"): each
    // aspect's Include is its own patterns, Exclude is every earlier aspect's patterns, all prefixed by the
    // unit root. The last aspect (the '**' catch-all) thus becomes "everything under the root minus every
    // earlier aspect" — the remainder.
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

    // Partition check (ADR-ASPECT:5) over a file universe: every file selected by exactly one aspect. Returns
    // human-readable violations (empty => a valid partition): a file claimed by two aspects breaks disjoint,
    // a file claimed by none breaks exhaustive.
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
