# pwsh/Base.Objects/types/GlobPattern.cs

One glob pattern of the durable-sha-globs dialect: repository-relative and `/`-separated
([FDR-GLOBS](../../../../drs/flow/durable-sha-globs.md),
[FDR-GLOBS-RELATIVEPATTERNS](../../../../drs/flow/durable-sha-globs.md#rule-fdr-globs-relativepatterns)).

## Dialect

`**` is the only cross-segment operator: a whole segment that consumes zero or more path segments. Within a segment the semantics are
exactly PowerShell wildcards (`*`, `?`, `[abc]`, `[a-z]`), delegated to the host's `System.Management.Automation.WildcardPattern` and
matched case-sensitively.

## Constructor guard

The constructor is the gate
([FDR-GLOBS-MALFORMEDPATTERNREJECTED](../../../../drs/flow/durable-sha-globs.md#rule-fdr-globs-malformedpatternrejected)). It rejects `\`, a
leading `/`, empty segments, `.` and `..` segments, a backtick (the dialect has no escape character), and `**` embedded inside a segment, so
a malformed pattern never produces an instance. `WildcardPattern` parses lazily, so the constructor forces the parse and a malformed
segment, such as an unclosed `[`, fails at construction and not at first match.

## Matching

- **The `**` walk** — it aligns pattern segments to path segments left to right. At a `**` it tries every number of consumed path segments,
  zero or more, and backtracks on failure.
- **`MatchingPaths`** — the paths, in their order, that at least one of the patterns matches. Each pattern is tried only on the paths under
  its literal prefix, so a list of many paths is matched in one call.
