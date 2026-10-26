# pwsh/Base.Objects/types/RepoRelativePath.cs

A path value that carries both forms of the path-representation contract
([ADR-AUTO-PATH](../../../../drs/automation/path-representation.md)): it stores the canonical repository-root-relative form, with forward
slashes and normalized, and derives the absolute binding form on demand via `ToAbsolute(root)`.

## Why relative is stored

Storing the relative form keeps records and configs portable and machine-independent. Deriving the absolute form only at the bind keeps the
value root-agnostic and serialization-safe: the relative string is the only thing persisted. A channel that renders the value picks:
`ToString()` or `Relative` for logs and storage
([ADR-AUTO-PATH-OUTPUTFORMATS](../../../../drs/automation/path-representation.md#rule-adr-auto-path-outputformats)), `ToAbsolute(root)` at
the point of binding
([ADR-AUTO-PATH-BINDINGFORMONLYATBINDING](../../../../drs/automation/path-representation.md#rule-adr-auto-path-bindingformonlyatbinding)).

## Input

The input is a communication-form path string. A rooted input has no repository-relative form and is kept as a normalized absolute path, the
degrade case ([ADR-AUTO-PATH-FOREIGNPATHS](../../../../drs/automation/path-representation.md#rule-adr-auto-path-foreignpaths)). A path
outside the root, such as system temp or a pipeline staging area, degrades the same way; `GetFullPath` collapses `.` and `..` there without
consulting the current directory, because the path is already rooted. A relative input that escapes the root with a leading `..` has no
valid communication form and throws.

## Members

- **`Relative`** — the canonical stored form: repository-root-relative with forward slashes when a relative form exists, otherwise a
  normalized absolute path. It is the only field persisted.
- **`IsRooted`** — true when there is no repository-relative form and `Relative` holds a normalized absolute path.
- **`ToAbsolute(repositoryRoot)`** — resolves to the absolute binding form against the supplied root, never the current directory. An
  already-rooted, degraded value is returned unchanged.

## Normalizing a relative path

A relative path has its `.`, `..`, leading `./` and duplicate separators collapsed with no base directory. `Path.GetFullPath` cannot be
used, since it would resolve a relative path against the current directory, which the rule never to depend on `$PWD` forbids, so the
segments are walked by hand.
