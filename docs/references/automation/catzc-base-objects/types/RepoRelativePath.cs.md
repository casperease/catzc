---
catzc:
  derived:
    path: docs/references/automation/catzc-base-objects/types/RepoRelativePath.cs.md
    kind: comment-page
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: adf3199054ab
    adrs:
      - ADR-AUTO-PATH#{3,5,8}
---

# automation/Catzc.Base.Objects/types/RepoRelativePath.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
A path value that carries both forms of the path-representation contract ([ADR-AUTO-PATH](/docs/adr/automation/path-representation.md)):
it stores the canonical repo-root-RELATIVE form (forward slashes, normalized) and derives the absolute
BINDING form on demand via ToAbsolute(root). Storing relative keeps records/configs portable and
machine-independent; deriving absolute only at the bind keeps the value root-agnostic and serialization-safe
(the relative string is the only thing persisted). A channel that renders the value picks: ToString()/Relative
for logs and storage ([ADR-AUTO-PATH#8](/docs/adr/automation/path-representation.md#rule-adr-auto-path8)), ToAbsolute(root) at the point
of binding ([ADR-AUTO-PATH#3](/docs/adr/automation/path-representation.md#rule-adr-auto-path3)).

Input is a communication-form path string. A rooted input has no
repo-relative form and is kept as a normalized absolute path — the degrade case
([ADR-AUTO-PATH#5](/docs/adr/automation/path-representation.md#rule-adr-auto-path5)). A relative input
that escapes the root (a leading '..') has no valid communication form and throws.
```

## comment:2

Above `public string Relative { get; }`, written with `//`.

```text
The canonical stored form: repo-root-relative with forward slashes when a relative form exists,
otherwise a normalized absolute path (the degrade case). This is the only field persisted.
```

## comment:3

Above `public bool IsRooted { get; }`, written with `//`.

```text
True when there is no repo-relative form and Relative holds a normalized absolute path
([ADR-AUTO-PATH#5](/docs/adr/automation/path-representation.md#rule-adr-auto-path5)).
```

## comment:4

Above `IsRooted = true;`, written with `//`.

```text
No repo-relative form (a path outside the root, e.g. system temp or a pipeline staging area):
degrade to a normalized absolute path. GetFullPath collapses '.'/'..' without consulting the
current directory because the path is already rooted.
```

## comment:5

Above `private static string NormalizeRelative(string relative)`, written with `//`.

```text
Collapse '.', '..', a leading './', and duplicate separators in a RELATIVE path with no base directory.
Path.GetFullPath cannot be used here — it would resolve a relative path against the current directory,
which never-depend-on-pwd forbids — so the segments are walked by hand.
```

## comment:6

Above `public string ToAbsolute(string repositoryRoot)`, written with `//`.

```text
Resolve to the absolute binding form against the repository root. An already-rooted (degraded) value is
returned unchanged. Resolution is against the supplied root, never the current directory.
```
