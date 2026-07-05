// One named globset: the deployable unit's mapping onto files under version control — a kebab-case name, a
// description, the include patterns, and the optional exclude patterns (a file belongs when it matches at
// least one include and no exclude, ADR-GLOBS:4). TriggerPath is the unit's committed trigger-file path
// (.triggers/<name>.sha256, ADR-GLOBS:1); no globset may match its own trigger file or the config itself
// (ADR-GLOBS:6), which GlobsConfig asserts across the whole registry at construction.
// See docs/adr/pipelines/durable-sha-globs.md.

using System;
using System.Collections.Generic;
using System.Text.RegularExpressions;

namespace Catzc.Base.Globs;

public sealed class GlobSet
{
    private static readonly Regex KebabCase = new Regex("^[a-z0-9]+(-[a-z0-9]+)*$");

    public string Name { get; }
    public string Description { get; }
    public IReadOnlyList<GlobPattern> Include { get; }
    public IReadOnlyList<GlobPattern> Exclude { get; }

    // The committed trigger file this globset's durable SHA is persisted in (ADR-GLOBS:1).
    public string TriggerPath
    {
        get { return ".triggers/" + Name + ".sha256"; }
    }

    public GlobSet(string name, string description, string[] include, string[] exclude)
    {
        if (string.IsNullOrWhiteSpace(name) || !KebabCase.IsMatch(name))
        {
            throw new ArgumentException(string.Format("globset name '{0}' must be kebab-case ([a-z0-9-])", name));
        }
        if (string.IsNullOrWhiteSpace(description))
        {
            throw new ArgumentException(string.Format("globset '{0}': a description is required", name));
        }
        if (include == null || include.Length == 0)
        {
            throw new ArgumentException(string.Format("globset '{0}': at least one include pattern is required", name));
        }

        Name = name;
        Description = description;
        Include = Compile(name, "include", include);
        Exclude = Compile(name, "exclude", exclude ?? new string[0]);
    }

    // Membership (ADR-GLOBS:4): at least one include matches and no exclude matches.
    public bool Matches(string repoRelativePath)
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
