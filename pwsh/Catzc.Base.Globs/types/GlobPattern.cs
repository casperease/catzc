/*
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.Globs/types/GlobPattern.cs
    folder: types
    name: glob-pattern
    filetype: cs
    role: type
    language: csharp
    track: pwsh
    tracktype: modules
    module: Catzc.Base.Globs
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    test: pwsh/Catzc.Base.Globs/tests/types/GlobPattern.Tests.ps1
    docs: "[GlobPattern.cs.md](docs/references/pwsh/catzc-base-globs/types/GlobPattern.cs.md)"
    cites:
      - ADR-FLOW-CD-GLOBS
---
*/

using System;
using System.Management.Automation;

namespace Catzc.Base.Globs;

public sealed class GlobPattern
{
    // The pattern as authored.
    public string Pattern { get; }

    // Per segment: the compiled per-segment matcher, or null where the segment is the '**' operator.
    private readonly WildcardPattern[] segments;
    private readonly bool[] isAnyDepth;

    public GlobPattern(string pattern)
    {
        if (string.IsNullOrWhiteSpace(pattern))
        {
            throw new ArgumentException("a glob pattern must be non-empty");
        }
        if (pattern.IndexOf('\\') >= 0)
        {
            throw new ArgumentException(string.Format("glob pattern '{0}': the separator is '/', never '\\' (ADR-FLOW-CD-GLOBS-MALFORMEDPATTERNREJECTED)", pattern));
        }
        if (pattern.IndexOf('`') >= 0)
        {
            throw new ArgumentException(string.Format("glob pattern '{0}': the dialect has no escape character — a backtick is rejected (ADR-FLOW-CD-GLOBS-MALFORMEDPATTERNREJECTED)", pattern));
        }
        if (pattern[0] == '/')
        {
            throw new ArgumentException(string.Format("glob pattern '{0}': patterns are repo-relative — no leading '/' (ADR-FLOW-CD-GLOBS-MALFORMEDPATTERNREJECTED)", pattern));
        }

        string[] parts = pattern.Split('/');
        WildcardPattern[] compiled = new WildcardPattern[parts.Length];
        bool[] anyDepth = new bool[parts.Length];

        for (int i = 0; i < parts.Length; i++)
        {
            string segment = parts[i];
            if (segment.Length == 0)
            {
                throw new ArgumentException(string.Format("glob pattern '{0}': empty segment (a trailing or doubled '/') (ADR-FLOW-CD-GLOBS-MALFORMEDPATTERNREJECTED)", pattern));
            }
            if (segment == "." || segment == "..")
            {
                throw new ArgumentException(string.Format("glob pattern '{0}': '.'/'..' segments are rejected (ADR-FLOW-CD-GLOBS-MALFORMEDPATTERNREJECTED)", pattern));
            }
            if (segment == "**")
            {
                anyDepth[i] = true;
                continue;
            }
            if (segment.Contains("**"))
            {
                throw new ArgumentException(string.Format("glob pattern '{0}': '**' must stand as a whole segment, never inside one (ADR-FLOW-CD-GLOBS-REPOSITORYRELATIVEPATTERNS)", pattern));
            }

            WildcardPattern wildcard = WildcardPattern.Get(segment, WildcardOptions.None);
            try
            {
                wildcard.IsMatch(string.Empty);
            }
            catch (WildcardPatternException ex)
            {
                throw new ArgumentException(string.Format("glob pattern '{0}': segment '{1}' is not a valid wildcard: {2}", pattern, segment, ex.Message));
            }
            compiled[i] = wildcard;
        }

        Pattern = pattern;
        segments = compiled;
        isAnyDepth = anyDepth;
    }

    // True when the repo-relative, '/'-separated path matches. A null/empty path matches nothing.
    public bool Matches(string repoRelativePath)
    {
        if (string.IsNullOrEmpty(repoRelativePath)) { return false; }
        return MatchFrom(0, repoRelativePath.Split('/'), 0);
    }

    private bool MatchFrom(int patternIndex, string[] path, int pathIndex)
    {
        while (patternIndex < segments.Length)
        {
            if (isAnyDepth[patternIndex])
            {
                if (patternIndex == segments.Length - 1) { return true; }
                for (int consumeTo = pathIndex; consumeTo <= path.Length; consumeTo++)
                {
                    if (MatchFrom(patternIndex + 1, path, consumeTo)) { return true; }
                }
                return false;
            }
            if (pathIndex >= path.Length) { return false; }
            if (!segments[patternIndex].IsMatch(path[pathIndex])) { return false; }
            patternIndex++;
            pathIndex++;
        }
        return pathIndex == path.Length;
    }

    public override string ToString()
    {
        return Pattern;
    }
}
