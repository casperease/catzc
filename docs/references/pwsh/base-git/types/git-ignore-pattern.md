# pwsh/Base.Git/types/GitIgnorePattern.cs

One pattern line inside a `gitignore.yml` section: a verbatim git wildmatch pattern with an optional trailing note, rendered as an aligned
inline comment.

## Input forms

A section's `patterns` list accepts either a bare string (just the pattern) or a `{ pattern, note }` mapping; `GitIgnoreSection` normalizes
both into this record. The pattern text is never rewritten: what the registry says is what `.gitignore` gets.

## Base type

It derives from `Catzc.Base.Objects.DictionaryRecord`, so an instance also presents as a read-only dictionary over its own properties and
its constructor uses the base's extraction helpers.
