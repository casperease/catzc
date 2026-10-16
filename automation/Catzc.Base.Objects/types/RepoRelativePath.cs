/*
---
catzc:
  derived:
    path: automation/Catzc.Base.Objects/types/RepoRelativePath.cs
    kind: csharp-type
    module: Catzc.Base.Objects
    relatives:
      page: docs/references/automation/catzc-base-objects/types/RepoRelativePath.cs.md
      test: automation/Catzc.Base.Objects/tests/types/RepoRelativePath.Tests.ps1
    adrs:
      - ADR-AUTO-PATH
---
*/

using System;
using System.Collections.Generic;
using System.IO;

namespace Catzc.Base.Objects;

public sealed class RepoRelativePath
{
    public string Relative { get; }

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
            IsRooted = true;
            Relative = Path.GetFullPath(slashed);
            return;
        }

        IsRooted = false;
        Relative = NormalizeRelative(slashed);
    }

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
