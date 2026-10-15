// The constructor is the gate: a malformed pattern never yields an instance, and the dialect has no escape character.
// [ADR-FLOW-CD-GLOBS](/docs/adr/flow/durable-sha-globs.md),
// [ADR-FLOW-CD-GLOBS#2](/docs/adr/flow/durable-sha-globs.md#rule-adr-flow-cd-globs2),
// [ADR-FLOW-CD-GLOBS#3](/docs/adr/flow/durable-sha-globs.md#rule-adr-flow-cd-globs3)
// [comment:1](/docs/references/automation/catzc-base-globs/types/GlobPattern.cs.md#comment1)

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
            throw new ArgumentException(string.Format("glob pattern '{0}': the separator is '/', never '\\' (ADR-FLOW-CD-GLOBS#3)", pattern));
        }
        if (pattern.IndexOf('`') >= 0)
        {
            throw new ArgumentException(string.Format("glob pattern '{0}': the dialect has no escape character — a backtick is rejected (ADR-FLOW-CD-GLOBS#3)", pattern));
        }
        if (pattern[0] == '/')
        {
            throw new ArgumentException(string.Format("glob pattern '{0}': patterns are repo-relative — no leading '/' (ADR-FLOW-CD-GLOBS#3)", pattern));
        }

        string[] parts = pattern.Split('/');
        WildcardPattern[] compiled = new WildcardPattern[parts.Length];
        bool[] anyDepth = new bool[parts.Length];

        for (int i = 0; i < parts.Length; i++)
        {
            string segment = parts[i];
            if (segment.Length == 0)
            {
                throw new ArgumentException(string.Format("glob pattern '{0}': empty segment (a trailing or doubled '/') (ADR-FLOW-CD-GLOBS#3)", pattern));
            }
            if (segment == "." || segment == "..")
            {
                throw new ArgumentException(string.Format("glob pattern '{0}': '.'/'..' segments are rejected (ADR-FLOW-CD-GLOBS#3)", pattern));
            }
            if (segment == "**")
            {
                anyDepth[i] = true;
                continue;
            }
            if (segment.Contains("**"))
            {
                throw new ArgumentException(string.Format("glob pattern '{0}': '**' must stand as a whole segment, never inside one (ADR-FLOW-CD-GLOBS#2)", pattern));
            }

            WildcardPattern wildcard = WildcardPattern.Get(segment, WildcardOptions.None);
            try
            {
                // WildcardPattern parses lazily, so force the parse: a malformed segment must fail here, not at first match.
                // [comment:2](/docs/references/automation/catzc-base-globs/types/GlobPattern.cs.md#comment2)
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

    // A '**' tries every count of consumed path segments, zero included, and backtracks on failure.
    // [comment:3](/docs/references/automation/catzc-base-globs/types/GlobPattern.cs.md#comment3)
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
