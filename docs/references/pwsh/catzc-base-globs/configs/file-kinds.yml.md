# pwsh/Base.Globs/configs/file-kinds.yml

The file-kinds registry: the one definition of what a file is, by role. `Get-FileKind` reads it through the typed
`Catzc.Base.Globs.FileKindsConfig` record (`FileKindsConfig.cs`).

## Kinds

A kind names the role and never the language, track or module, which are keys of their own in a file's head. Kinds are checked in the order
written: the first whose globs, or whose subkinds' globs, match a path names it, and a file no entry selects is `other`. A consumer extends
the registry in a config fragment, which adds a kind (checked after these) or replaces the globs of one.

## Overlaps

The `overlaps` list holds the intended overlaps as `[earlier, later]` pairs: the earlier kind takes most of the later kind's files on
purpose, since the later one is the catch-all of its tree. A kind mostly shadowed by a pair not listed here fails
`Test-FileKindReachability`.
