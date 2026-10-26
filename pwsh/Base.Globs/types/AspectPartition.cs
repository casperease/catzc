using System;
using System.Collections.Generic;

namespace Catzc.Base.Globs;

public static class AspectPartition
{
    // Each aspect includes its own patterns and excludes every earlier aspect's, so the last one is the remainder.
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

    // The first aspect, in map order, one of whose sets claims the file; null when none does.
    public static string AspectOf(System.Collections.IDictionary sets, string file)
    {
        if (sets == null) { throw new ArgumentNullException("sets"); }
        foreach (System.Collections.DictionaryEntry entry in sets)
        {
            System.Collections.IEnumerable members = entry.Value as System.Collections.IEnumerable;
            if (members == null) { continue; }
            foreach (object member in members)
            {
                GlobSet set = member as GlobSet;
                if (set != null && set.Matches(file)) { return entry.Key.ToString(); }
            }
        }
        return null;
    }

    // Every file in exactly one aspect: a file in two breaks disjoint, a file in none breaks exhaustive.
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
