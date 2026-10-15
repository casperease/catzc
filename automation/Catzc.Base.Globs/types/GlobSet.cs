// One named globset: an area-of-control's mapping onto files under version control — a kebab-case name, a description, its layer...
// [ADR-FLOW-CD-GLOBS#7](/docs/adr/flow/durable-sha-globs.md#rule-adr-flow-cd-globs7),
// [ADR-FLOW-CD-GLOBS#8](/docs/adr/flow/durable-sha-globs.md#rule-adr-flow-cd-globs8),
// [ADR-FLOW-CD-GLOBS#4](/docs/adr/flow/durable-sha-globs.md#rule-adr-flow-cd-globs4),
// [ADR-FLOW-CD-GLOBS#5](/docs/adr/flow/durable-sha-globs.md#rule-adr-flow-cd-globs5),
// [ADR-FLOW-CD-GLOBS#10](/docs/adr/flow/durable-sha-globs.md#rule-adr-flow-cd-globs10),
// [ADR-FLOW-CD-GLOBS](/docs/adr/flow/durable-sha-globs.md)
// [comment:1](/docs/references/automation/catzc-base-globs/types/GlobSet.cs.md#comment1)

using System;
using System.Collections.Generic;
using System.Text.RegularExpressions;

namespace Catzc.Base.Globs;

public sealed class GlobSet
{
    private static readonly Regex KebabCase = new Regex("^[a-z0-9]+(-[a-z0-9]+)*$");

    // The layers — three kinds of thing: 'deployable-unit' (a configurable unit that ships) and 'loose-fileset' (a cross-cutting check...
    // [ADR-FLOW-CD-GLOBS#7](/docs/adr/flow/durable-sha-globs.md#rule-adr-flow-cd-globs7),
    // [ADR-REPO-PROTGLOB](/docs/adr/repository/protected-globs.md),
    // [ADR-FLOW-CD-GLOBS#10](/docs/adr/flow/durable-sha-globs.md#rule-adr-flow-cd-globs10)
    // [comment:2](/docs/references/automation/catzc-base-globs/types/GlobSet.cs.md#comment2)
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

    // The flattened scan program, built lazily from composed + own rules and cached (composed is immutable after ResolveCompose, which...
    // [comment:3](/docs/references/automation/catzc-base-globs/types/GlobSet.cs.md#comment3)
    private IReadOnlyList<ScanRule> cachedProgram;

    // A single scan-program rule: Select true = '+' (select), false = '-' (drop).
    // [ADR-FLOW-CD-GLOBS#4](/docs/adr/flow/durable-sha-globs.md#rule-adr-flow-cd-globs4)
    // [comment:4](/docs/references/automation/catzc-base-globs/types/GlobSet.cs.md#comment4)
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
                "globset '{0}': layer '{1}' is not a layer (allowed: {2}, ADR-FLOW-CD-GLOBS#7)",
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

    // Called by GlobsConfig after construction, with the referenced sets in Compose order.
    // [comment:5](/docs/references/automation/catzc-base-globs/types/GlobSet.cs.md#comment5)
    internal void ResolveCompose(IReadOnlyList<GlobSet> resolved)
    {
        composed = resolved;
        cachedProgram = null;
    }

    // Membership: evaluate the scan program last-match-wins, default not-selected — a file belongs when its last matching rule is '+'.
    // [ADR-FLOW-CD-GLOBS#4](/docs/adr/flow/durable-sha-globs.md#rule-adr-flow-cd-globs4)
    // [comment:6](/docs/references/automation/catzc-base-globs/types/GlobSet.cs.md#comment6)
    public bool Matches(string repoRelativePath)
    {
        bool selected = false;
        foreach (ScanRule rule in ScanProgram())
        {
            if (rule.Pattern.Matches(repoRelativePath)) { selected = rule.Select; }
        }
        return selected;
    }

    // OWN membership: the set's own program only — its includes as '+' then its excludes as '-', last-match-wins — with compose IGNORED.
    // [ADR-FLOW-CD-GLOBS#10](/docs/adr/flow/durable-sha-globs.md#rule-adr-flow-cd-globs10)
    // [comment:7](/docs/references/automation/catzc-base-globs/types/GlobSet.cs.md#comment7)
    public bool OwnMatches(string repoRelativePath)
    {
        bool selected = false;
        foreach (GlobPattern pattern in Include) { if (pattern.Matches(repoRelativePath)) { selected = true; } }
        foreach (GlobPattern pattern in Exclude) { if (pattern.Matches(repoRelativePath)) { selected = false; } }
        return selected;
    }

    // The members of a tracked-file universe (`git ls-files`, fetched once by the caller and passed in — never cached here, since...
    // [comment:8](/docs/references/automation/catzc-base-globs/types/GlobSet.cs.md#comment8)
    public string[] SelectMembers(IReadOnlyList<string> tracked)
    {
        return Select(tracked, Matches);
    }

    // The OWN members (OwnMatches, compose ignored) of a tracked-file universe, in ordinal order — the per-layer independence check's...
    // [ADR-FLOW-CD-GLOBS#10](/docs/adr/flow/durable-sha-globs.md#rule-adr-flow-cd-globs10)
    // [comment:9](/docs/references/automation/catzc-base-globs/types/GlobSet.cs.md#comment9)
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

    // The flattened scan program (/8): the composed sets' programs first (dependency order, deepest base first), then this set's own...
    // [ADR-FLOW-CD-GLOBS#4](/docs/adr/flow/durable-sha-globs.md#rule-adr-flow-cd-globs4)
    // [comment:10](/docs/references/automation/catzc-base-globs/types/GlobSet.cs.md#comment10)
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
