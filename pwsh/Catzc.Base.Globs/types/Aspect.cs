/*
---
catzc:
  immutable:
    with_body_sha: "63aeab9d31b2"
  edges:
    test: pwsh/Catzc.Base.Globs/tests/types/Aspect.Tests.ps1
    docs: "[Aspect.cs.md](docs/references/pwsh/catzc-base-globs/types/Aspect.cs.md)"
    cites:
      - ADR-DSGN-ASPECT
      - ADR-FLOW-CD-GLOBS-TRACKEDFILESONLY
---
*/

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
