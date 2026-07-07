// One named globset: an area-of-control's mapping onto files under version control — a kebab-case name, a
// description, its layer (deployable-unit | loose-fileset, ADR-GLOBS:7; the derived module layer never
// appears in the registry), the authored include/exclude patterns, and the optional composition
// (ADR-GLOBS:8). Membership is decided by the set's SCAN PROGRAM (ADR-GLOBS:4): an ordered list of +/- rules
// evaluated last-match-wins with a default of not-selected. A leaf set's program is its includes as '+' then
// its excludes as '-' (excludes come last and win). A composing set's program is the composed sets' programs
// first (dependency order, deepest base first, each set once), then its own +/- rules LAST — so a set's own
// rules override its base (it re-adds a slice the base dropped). The program is the marker's core: the
// Representation renders it as the scan: block, and the durable SHA (ADR-GLOBS:5) is computed over exactly
// what the program selects.
// Verify (test blast-radius scope) and Pipeline (the trigger-role binding) are declarative meta annotations.
// A globset never composes itself and the compose graph is acyclic (ADR-GLOBS:8), which GlobsConfig asserts
// across the whole registry at construction.
// Per-layer independence (ADR-GLOBS:10) is decided on OWN membership (OwnMatches — the set's own rules only,
// compose ignored): within a non-loose layer no two sets may select a common file on their OWN contribution.
// See docs/adr/pipelines/durable-sha-globs.md.

using System;
using System.Collections.Generic;
using System.Text.RegularExpressions;

namespace Catzc.Base.Globs;

public sealed class GlobSet
{
    private static readonly Regex KebabCase = new Regex("^[a-z0-9]+(-[a-z0-9]+)*$");

    // The layers (ADR-GLOBS:7) — three kinds of thing: 'deployable-unit' (a configurable unit that ships) and
    // 'loose-fileset' (a cross-cutting check surface — a track's root concern like automation/infrastructure,
    // a scan scope, the reserved umbrellas — that carries a demonstrated use, e.g. a pipeline, and deliberately
    // overlaps the boundaries it cuts across). 'module' is the DERIVED layer (ADR-PROTGLOB) — the per-folder
    // module partition plus the 'module-leftovers' catch-all — a valid GlobSet layer (Get-ModuleGlobSet
    // constructs them), but GlobsConfig rejects it in the declared registry. Within every layer but
    // 'loose-fileset' the sets are pairwise-disjoint on OWN membership (ADR-GLOBS:10).
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

    // The flattened scan program, built lazily from composed + own rules and cached (composed is immutable
    // after ResolveCompose, which clears this). One rule: select (+) or drop (-) a pattern.
    private IReadOnlyList<ScanRule> cachedProgram;

    // A single scan-program rule (ADR-GLOBS:4): Select true = '+' (select), false = '-' (drop).
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
                "globset '{0}': layer '{1}' is not a layer (allowed: {2}, ADR-GLOBS:7)",
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

    // Called by GlobsConfig after construction, with the referenced sets in Compose order. Clears the cached
    // program so it rebuilds against the resolved composition.
    internal void ResolveCompose(IReadOnlyList<GlobSet> resolved)
    {
        composed = resolved;
        cachedProgram = null;
    }

    // Membership (ADR-GLOBS:4): evaluate the scan program last-match-wins, default not-selected — a file
    // belongs when its last matching rule is '+'.
    public bool Matches(string repoRelativePath)
    {
        bool selected = false;
        foreach (ScanRule rule in ScanProgram())
        {
            if (rule.Pattern.Matches(repoRelativePath)) { selected = rule.Select; }
        }
        return selected;
    }

    // OWN membership (ADR-GLOBS:10): the set's own program only — its includes as '+' then its excludes as
    // '-', last-match-wins — with compose IGNORED. This is the set's OWN contribution, the slice it maps
    // independent of any base it composes: a file belongs when the set selects it without help from a base.
    // The per-layer independence gate is defined on this, never on effective (Matches) membership — compose
    // is "depends on a base," a deliberate cross-layer overlap, not a peer overlap.
    public bool OwnMatches(string repoRelativePath)
    {
        bool selected = false;
        foreach (GlobPattern pattern in Include) { if (pattern.Matches(repoRelativePath)) { selected = true; } }
        foreach (GlobPattern pattern in Exclude) { if (pattern.Matches(repoRelativePath)) { selected = false; } }
        return selected;
    }

    // The flattened scan program (ADR-GLOBS:4/8): the composed sets' programs first (dependency order,
    // deepest base first), then this set's own rules (includes as '+', excludes as '-') LAST, so own rules
    // override the base. Identical (op, pattern) rules are deduped keeping the LAST occurrence — harmless for
    // last-match-wins and keeps a diamond compose from repeating rules. Built lazily and cached.
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
