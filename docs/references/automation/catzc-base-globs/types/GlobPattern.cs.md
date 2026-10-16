---
catzc:
  derived:
    path: docs/references/automation/catzc-base-globs/types/GlobPattern.cs.md
    kind: comment-page
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "87088394ff85"
    adrs:
      - ADR-FLOW-CD-GLOBS#{2,3}
---

# automation/Catzc.Base.Globs/types/GlobPattern.cs

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
See [ADR-FLOW-CD-GLOBS](/docs/adr/flow/durable-sha-globs.md)
([ADR-FLOW-CD-GLOBS#2](/docs/adr/flow/durable-sha-globs.md#rule-adr-flow-cd-globs2),
[ADR-FLOW-CD-GLOBS#3](/docs/adr/flow/durable-sha-globs.md#rule-adr-flow-cd-globs3)).
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
