using System;
using System.Collections.Generic;
using System.IO;

namespace Catzc.Base.Objects;

// A path in both forms of the path contract: it stores the canonical repo-relative form and binds absolute on demand.
public sealed class RepoRelativePath
{
    // The only persisted field: repo-relative with forward slashes, else a normalized absolute path.
    public string Relative { get; }

    // True when no repo-relative form exists and Relative holds a normalized absolute path.
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
            // No repo-relative form, a path outside the root: degrade to a normalized absolute path.
            IsRooted = true;
            Relative = Path.GetFullPath(slashed);
            return;
        }

        IsRooted = false;
        Relative = NormalizeRelative(slashed);
    }

    // Collapses '.', '..', a leading './' and doubled separators with no base; GetFullPath would resolve against the current directory.
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

    // Against the supplied root, never the current directory; a degraded, rooted value is returned unchanged.
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
