---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-inspiration/types/InspirationRoot.cs.md
    kind: comment-page
    body_sha: "45c0173f67fc"
    adrs:
      - ADR-AUTO-PATH#11
      - ADR-AUTO-PATH#3
      - ADR-AUTO-PATH#6
---

# automation/Catzc.Tooling.Inspiration/types/InspirationRoot.cs

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `using System;`.

```text
The stored form of an inspiration's root and its resolution to binding form. A root is stored in communication
form ([ADR-AUTO-PATH#6](/docs/adr/automation/path-representation.md#rule-adr-auto-path6)): repository-relative, or
anchored on the {workspace} anchor — the parent folder of the repository root, where sibling checkouts live
([ADR-AUTO-PATH#11](/docs/adr/automation/path-representation.md#rule-adr-auto-path11)). Resolve turns either into a
'/'-separated absolute path, the binding form ([ADR-AUTO-PATH#3](/docs/adr/automation/path-representation.md#rule-adr-auto-path3)).

The repository root reaches the resolver in the view of the shell that set it: 'C:\projects\catzc' under pwsh,
'/c/projects/catzc' under Git Bash. ToNative maps both to one form, so the two shells resolve a root identically.
The platform is a parameter, not a probe, so every branch is deterministic and testable on any OS.
```

## comment:2

Above `public static string[] Violations(string label, string value, bool allowAnchor)`.

```text
Every way a stored path breaks communication form, as messages naming 'label'. A root may carry the
{workspace} anchor as its first segment (allowAnchor); a path inside a root never does. Empty when valid.
```

## comment:3

Above `public static string ToNative(string path, bool windows)`.

```text
Maps a path in either shell's view to the platform's own form, '/'-separated: backslashes become '/', and on
Windows a Git Bash drive path ('/c/projects') becomes a drive path ('C:/projects'). Elsewhere a '/c/...'
path is a real path and is left as it is.
```
