using System;
using System.Collections.Generic;
using System.Text.RegularExpressions;
using Catzc.Base.Objects;

namespace Catzc.Base.Globs;

// Membership is the scan program, last match wins: composed sets first, the set's own rules last.
public sealed class GlobSet
{
    private static readonly Regex KebabCase = new Regex("^[a-z0-9]+(-[a-z0-9]+)*$");

    // 'module' is the derived layer: a valid GlobSet layer that the declared registry rejects.
    public static readonly string[] DeclaredLayers = { "deployable-unit", "loose-fileset" };
    public static readonly string[] ValidLayers = { "deployable-unit", "loose-fileset", "module" };

    public string Name { get; }
    public string Description { get; }
    public string Layer { get; }
    public IReadOnlyList<GlobPattern> Include { get; }
    public IReadOnlyList<GlobPattern> Exclude { get; }
    public IReadOnlyList<string> Compose { get; }
    public IReadOnlyList<string> VerifyModules { get; }
    public int VerifyLevel { get; }      // -1 when the set declares no verify scope
    public string Pipeline { get; }      // null when the set binds no pipeline

    // The composed sets, resolved by GlobsConfig once every set is constructed (names validated there).
    private IReadOnlyList<GlobSet> composed = new GlobSet[0];

    // Built lazily and cached; ResolveCompose clears it.
    private IReadOnlyList<ScanRule> cachedProgram;

    // Select true is '+', false is '-'.
    public readonly struct ScanRule
    {
        public bool Select { get; }
        public GlobPattern Pattern { get; }
        public ScanRule(bool select, GlobPattern pattern)
        {
            Select = select;
            Pattern = pattern;
        }
    }

    public GlobSet(string name, string description, string layer, string[] include, string[] exclude,
        string[] compose, string[] verifyModules, int verifyLevel, string pipeline)
    {
        if (string.IsNullOrWhiteSpace(name) || !KebabCase.IsMatch(name))
        {
            throw new ArgumentException(string.Format("globset name '{0}' must be kebab-case ([a-z0-9-])", name));
        }
        if (string.IsNullOrWhiteSpace(description))
        {
            throw new ArgumentException(string.Format("globset '{0}': a description is required", name));
        }
        if (string.IsNullOrWhiteSpace(layer) || Array.IndexOf(ValidLayers, layer) < 0)
        {
            throw new ArgumentException(string.Format(
                "globset '{0}': layer '{1}' is not a layer (allowed: {2}, FDR-GLOBS-EVERYSETHASLAYER)",
                name, layer, string.Join(", ", ValidLayers)));
        }
        bool hasInclude = include != null && include.Length > 0;
        bool hasCompose = compose != null && compose.Length > 0;
        if (!hasInclude && !hasCompose)
        {
            throw new ArgumentException(string.Format("globset '{0}': at least one include pattern or one compose reference is required", name));
        }
        if (verifyLevel < -1 || verifyLevel > 3)
        {
            throw new ArgumentException(string.Format("globset '{0}': verify level must be 0-3", name));
        }

        Name = name;
        Description = description;
        Layer = layer;
        Include = Compile(name, "include", include ?? new string[0]);
        Exclude = Compile(name, "exclude", exclude ?? new string[0]);
        Compose = compose ?? new string[0];
        VerifyModules = verifyModules ?? new string[0];
        VerifyLevel = verifyLevel;
        Pipeline = string.IsNullOrWhiteSpace(pipeline) ? null : pipeline;
    }

    // The referenced sets in compose order; clears the cached program so it rebuilds.
    internal void ResolveCompose(IReadOnlyList<GlobSet> resolved)
    {
        composed = resolved;
        cachedProgram = null;
    }

    // Last match wins, default not selected: a file belongs when its last matching rule is '+'.
    public bool Matches(string repoRelativePath)
    {
        bool selected = false;
        foreach (ScanRule rule in ScanProgram())
        {
            if (rule.Pattern.Matches(repoRelativePath)) { selected = rule.Select; }
        }
        return selected;
    }

    // The set's own rules only, compose ignored: what the per-layer independence gate compares.
    public bool OwnMatches(string repoRelativePath)
    {
        bool selected = false;
        foreach (GlobPattern pattern in Include) { if (pattern.Matches(repoRelativePath)) { selected = true; } }
        foreach (GlobPattern pattern in Exclude) { if (pattern.Matches(repoRelativePath)) { selected = false; } }
        return selected;
    }

    // The caller passes git ls-files in, never cached here, since staging changes it.
    public string[] SelectMembers(IReadOnlyList<string> tracked)
    {
        return Select(tracked, Matches);
    }

    // Own members of the tracked universe, in ordinal order: the independence check's input.
    public string[] SelectOwnMembers(IReadOnlyList<string> tracked)
    {
        return Select(tracked, OwnMatches);
    }

    private static string[] Select(IReadOnlyList<string> tracked, Func<string, bool> predicate)
    {
        if (tracked == null)
        {
            throw new ArgumentNullException(nameof(tracked));
        }
        List<string> members = new List<string>();
        foreach (string path in tracked)
        {
            if (predicate(path)) { members.Add(path); }
        }
        string[] sorted = members.ToArray();
        Array.Sort(sorted, StringComparer.Ordinal);
        return sorted;
    }

    // Composed programs first, in dependency order, each set once; own rules last, so they override the base.
    public IReadOnlyList<ScanRule> ScanProgram()
    {
        if (cachedProgram == null)
        {
            List<ScanRule> rules = new List<ScanRule>();
            AppendProgram(this, rules);
            cachedProgram = DedupeKeepingLast(rules);
        }
        return cachedProgram;
    }

    private static void AppendProgram(GlobSet set, List<ScanRule> rules)
    {
        foreach (GlobSet composedSet in set.composed)
        {
            AppendProgram(composedSet, rules);
        }
        foreach (GlobPattern pattern in set.Include) { rules.Add(new ScanRule(true, pattern)); }
        foreach (GlobPattern pattern in set.Exclude) { rules.Add(new ScanRule(false, pattern)); }
    }

    private static IReadOnlyList<ScanRule> DedupeKeepingLast(List<ScanRule> rules)
    {
        List<ScanRule> deduped = new List<ScanRule>();
        for (int i = 0; i < rules.Count; i++)
        {
            bool laterDuplicate = false;
            for (int j = i + 1; j < rules.Count; j++)
            {
                if (rules[j].Select == rules[i].Select
                    && string.Equals(rules[j].Pattern.Pattern, rules[i].Pattern.Pattern, StringComparison.Ordinal))
                {
                    laterDuplicate = true;
                    break;
                }
            }
            if (!laterDuplicate) { deduped.Add(rules[i]); }
        }
        return deduped;
    }

    private static IReadOnlyList<GlobPattern> Compile(string name, string listName, string[] patterns)
    {
        List<GlobPattern> compiled = new List<GlobPattern>();
        HashSet<string> seen = new HashSet<string>(StringComparer.Ordinal);
        foreach (string pattern in patterns)
        {
            if (!seen.Add(pattern))
            {
                throw new ArgumentException(string.Format("globset '{0}': duplicate {1} pattern '{2}'", name, listName, pattern));
            }
            try
            {
                compiled.Add(new GlobPattern(pattern));
            }
            catch (ArgumentException ex)
            {
                throw new ArgumentException(string.Format("globset '{0}' ({1}): {2}", name, listName, ex.Message));
            }
        }
        return compiled;
    }

    public override string ToString()
    {
        return Name;
    }
}
