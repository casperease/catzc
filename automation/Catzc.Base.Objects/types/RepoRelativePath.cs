// A path value that carries both forms of the path-representation contract: it stores the canonical repo-root-RELATIVE form (forward...
// [ADR-AUTO-PATH](/docs/adr/automation/path-representation.md),
// [ADR-AUTO-PATH#8](/docs/adr/automation/path-representation.md#rule-adr-auto-path8),
// [ADR-AUTO-PATH#3](/docs/adr/automation/path-representation.md#rule-adr-auto-path3),
// [ADR-AUTO-PATH#5](/docs/adr/automation/path-representation.md#rule-adr-auto-path5)
// [comment:1](/docs/references/automation/catzc-base-objects/types/RepoRelativePath.cs.md#comment1)

using System;
using System.Collections.Generic;
using System.IO;

namespace Catzc.Base.Objects;

public sealed class RepoRelativePath
{
    // The canonical stored form: repo-root-relative with forward slashes when a relative form exists, otherwise a normalized absolute...
    // [comment:2](/docs/references/automation/catzc-base-objects/types/RepoRelativePath.cs.md#comment2)
    public string Relative { get; }

    // True when there is no repo-relative form and Relative holds a normalized absolute path.
    // [ADR-AUTO-PATH#5](/docs/adr/automation/path-representation.md#rule-adr-auto-path5)
    // [comment:3](/docs/references/automation/catzc-base-objects/types/RepoRelativePath.cs.md#comment3)
    public bool IsRooted { get; }

    public RepoRelativePath(string path)
    {
        if (string.IsNullOrWhiteSpace(path))
        {
            throw new ArgumentException("RepoRelativePath requires a non-empty path");
        }

        string slashed = path.Replace('\\', '/').Trim();

        if (Path.IsPathRooted(slashed))
        {
            // No repo-relative form (a path outside the root, e.g.
            // [comment:4](/docs/references/automation/catzc-base-objects/types/RepoRelativePath.cs.md#comment4)
            IsRooted = true;
            Relative = Path.GetFullPath(slashed);
            return;
        }

        IsRooted = false;
        Relative = NormalizeRelative(slashed);
    }

    // Collapse '.', '..', a leading './', and duplicate separators in a RELATIVE path with no base directory.
    // [comment:5](/docs/references/automation/catzc-base-objects/types/RepoRelativePath.cs.md#comment5)
    private static string NormalizeRelative(string relative)
    {
        List<string> segments = new List<string>();
        foreach (string part in relative.Split('/'))
        {
            if (part.Length == 0 || part == ".")
            {
                continue;
            }
            if (part == "..")
            {
                if (segments.Count == 0)
                {
                    throw new ArgumentException("path escapes the repository root: " + relative);
                }
                segments.RemoveAt(segments.Count - 1);
                continue;
            }
            segments.Add(part);
        }
        if (segments.Count == 0)
        {
            throw new ArgumentException("path resolves to the repository root itself, which is not a relative path: " + relative);
        }
        return string.Join("/", segments);
    }

    // Resolve to the absolute binding form against the repository root.
    // [comment:6](/docs/references/automation/catzc-base-objects/types/RepoRelativePath.cs.md#comment6)
    public string ToAbsolute(string repositoryRoot)
    {
        if (IsRooted)
        {
            return Relative;
        }
        if (string.IsNullOrWhiteSpace(repositoryRoot))
        {
            throw new ArgumentException("repositoryRoot is required to resolve a relative path to absolute");
        }
        return Path.GetFullPath(Path.Combine(repositoryRoot, Relative));
    }

    public override string ToString()
    {
        return Relative;
    }

    public override bool Equals(object obj)
    {
        RepoRelativePath other = obj as RepoRelativePath;
        return other != null && string.Equals(Relative, other.Relative, StringComparison.Ordinal);
    }

    public override int GetHashCode()
    {
        return StringComparer.Ordinal.GetHashCode(Relative);
    }
}
