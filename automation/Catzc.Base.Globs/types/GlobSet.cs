// One named globset: an area-of-control's mapping onto files under version control — a kebab-case name, a
// description, its layer (deployable-unit | track | scope, ADR-GLOBS:7; the derived module layer never
// appears in the registry), the include patterns, the optional exclude patterns (a file belongs when it
// matches at least one include and no exclude, ADR-GLOBS:4), and the optional composition (ADR-GLOBS:8):
// the set's effective membership is its own patterns' members UNION the composed sets' effective members.
// Verify (test blast-radius scope) and Pipeline (the trigger-role binding) are declarative annotations.
// MarkerPath is the set's committed sha-marker path (.sha-markers/<name>.sha256, ADR-GLOBS:1); no globset
// may match its own marker file or the config itself (ADR-GLOBS:6), which GlobsConfig asserts across the
// whole registry at construction — compose resolution included.
// See docs/adr/pipelines/durable-sha-globs.md.

using System;
using System.Collections.Generic;
using System.Text.RegularExpressions;

namespace Catzc.Base.Globs;

public sealed class GlobSet
{
    private static readonly Regex KebabCase = new Regex("^[a-z0-9]+(-[a-z0-9]+)*$");

    // The declared layers (ADR-GLOBS:7). 'module' is the DERIVED layer (ADR-PROTGLOB) — a valid GlobSet
    // layer (Get-ModuleGlobSet constructs them), but GlobsConfig rejects it in the declared registry.
    public static readonly string[] DeclaredLayers = { "deployable-unit", "track", "scope" };
    public static readonly string[] ValidLayers = { "deployable-unit", "track", "scope", "module" };

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

    // The committed sha-marker file this globset's durable SHA is persisted in (ADR-GLOBS:1).
    public string MarkerPath
    {
        get { return ".sha-markers/" + Name + ".sha256"; }
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

    // Called by GlobsConfig after construction, with the referenced sets in Compose order.
    internal void ResolveCompose(IReadOnlyList<GlobSet> resolved)
    {
        composed = resolved;
    }

    // Effective membership (ADR-GLOBS:4 + ADR-GLOBS:8): the set's own include-minus-exclude members,
    // union the composed sets' effective members.
    public bool Matches(string repoRelativePath)
    {
        if (MatchesOwn(repoRelativePath)) { return true; }
        foreach (GlobSet set in composed)
        {
            if (set.Matches(repoRelativePath)) { return true; }
        }
        return false;
    }

    private bool MatchesOwn(string repoRelativePath)
    {
        bool included = false;
        foreach (GlobPattern pattern in Include)
        {
            if (pattern.Matches(repoRelativePath)) { included = true; break; }
        }
        if (!included) { return false; }
        foreach (GlobPattern pattern in Exclude)
        {
            if (pattern.Matches(repoRelativePath)) { return false; }
        }
        return true;
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
