// A path value that carries both forms of the path-representation contract (docs/adr/automation/path-representation.md):
// it stores the canonical repo-root-RELATIVE form (forward slashes, normalized) and derives the absolute
// BINDING form on demand via ToAbsolute(root). Storing relative keeps records/configs portable and
// machine-independent; deriving absolute only at the bind keeps the value root-agnostic and serialization-safe
// (the relative string is the only thing persisted). A channel that renders the value picks: ToString()/Relative
// for logs and storage (ADR-AUTO-PATH:8), ToAbsolute(root) at the point of binding (ADR-AUTO-PATH:3).
//
// Input is a communication-form path string. A rooted input has no
// repo-relative form and is kept as a normalized absolute path — the degrade case (ADR-AUTO-PATH:5). A relative input
// that escapes the root (a leading '..') has no valid communication form and throws.

using System;
using System.Collections.Generic;
using System.IO;

namespace Catzc.Base.Objects;

public sealed class RepoRelativePath
{
    // The canonical stored form: repo-root-relative with forward slashes when a relative form exists,
    // otherwise a normalized absolute path (the degrade case). This is the only field persisted.
    public string Relative { get; }

    // True when there is no repo-relative form and Relative holds a normalized absolute path (ADR-AUTO-PATH:5).
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
            // No repo-relative form (a path outside the root, e.g. system temp or a pipeline staging area):
            // degrade to a normalized absolute path. GetFullPath collapses '.'/'..' without consulting the
            // current directory because the path is already rooted.
            IsRooted = true;
            Relative = Path.GetFullPath(slashed);
            return;
        }

        IsRooted = false;
        Relative = NormalizeRelative(slashed);
    }

    // Collapse '.', '..', a leading './', and duplicate separators in a RELATIVE path with no base directory.
    // Path.GetFullPath cannot be used here — it would resolve a relative path against the current directory,
    // which never-depend-on-pwd forbids — so the segments are walked by hand.
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

    // Resolve to the absolute binding form against the repository root. An already-rooted (degraded) value is
    // returned unchanged. Resolution is against the supplied root, never the current directory.
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
