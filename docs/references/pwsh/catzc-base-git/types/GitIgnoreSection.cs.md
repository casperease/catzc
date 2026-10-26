# pwsh/Base.Git/types/GitIgnoreSection.cs

One section of the gitignore registry (`configs/gitignore.yml`): a titled, explained group of ignore patterns.

## Patterns or inject

A section declares either `patterns` (a static list, each a bare string or `{ pattern, note }`) or `inject: <provider>` (the patterns are
supplied at render time by the caller, for example the root-config registry's `committed: false` targets), never both. `inject` is the name
of the render-time pattern provider (for example `rootconfig-committed-false`).

## Title and why

`title` and `why` render as the section's comment block, so every rule in the generated `.gitignore` carries its explanation.

## Base type

It derives from `Catzc.Base.Objects.DictionaryRecord`, so an instance also presents as a read-only dictionary over its own properties and
its constructor uses the base's extraction helpers.
