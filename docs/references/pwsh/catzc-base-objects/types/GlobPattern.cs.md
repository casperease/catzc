# pwsh/Base.Objects/types/GlobPattern.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
One glob pattern of the durable-sha-globs dialect: repo-relative, '/'-separated; '**' is the only
cross-segment operator (a whole segment, consuming zero or more path segments); within a segment the
semantics are exactly PowerShell wildcards ('*', '?', '[abc]'/'[a-z]'), delegated to the host's
System.Management.Automation.WildcardPattern, matched case-sensitively. The constructor is the gate:
it rejects '\', a leading '/', empty segments, '.'/'..' segments, a backtick (the dialect has no escape
character), and '**' embedded inside a segment — a malformed pattern never produces an instance.
See [FDR-CD-GLOBS](/docs/drs/flow/durable-sha-globs.md)
([FDR-CD-GLOBS-REPOSITORYRELATIVEPATTERNS](/docs/drs/flow/durable-sha-globs.md#rule-fdr-cd-globs-repositoryrelativepatterns),
[FDR-CD-GLOBS-MALFORMEDPATTERNREJECTED](/docs/drs/flow/durable-sha-globs.md#rule-fdr-cd-globs-malformedpatternrejected)).
```

## comment:2

Above `wildcard.IsMatch(string.Empty);`, written with `//`.

```text
WildcardPattern parses lazily; force the parse so a malformed segment (e.g. an unclosed
'[') fails here, at construction, not at first match.
```

## comment:3

Above `private bool MatchFrom(int patternIndex, string[] path, int pathIndex)`, written with `//`.

```text
The '**' walk: align pattern segments to path segments left to right; at a '**', try every number of
consumed path segments (zero or more) and backtrack on failure.
```

## comment:4

Above `public static string[] MatchingPaths(string[] patterns, string[]...`, written with `//`.

```text
The paths, in their order, that at least one of the patterns matches; each pattern is tried only on the paths under its literal
prefix, so a list of many paths is matched in one call.
```
