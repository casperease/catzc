# pwsh/Base.Docs/types/DocPattern.cs

One glob-based convention from `configs/readme.yml`: every folder matched by `glob` receives a generated README whose source is the folder's
module article, which the comment-pages resolver derives from `configs/comment-pages.yml`. A pattern therefore names no source of its own.
The glob is a repository-root-relative, '/'-separated communication-form value
([ADR-AUTO-PATH](../../../../drs/automation/path-representation.md)). It mirrors a `readme.yml` patterns entry, snake_case keys.

It derives from `Catzc.Base.Objects.DictionaryRecord`, so an instance also presents as a read-only dictionary over its own properties and
its constructor uses the base's `Req` extraction helper.

## Properties

- **`glob`** — required; the repository-relative glob whose matched module folders each receive a generated README.

## Validation

The constructor rejects a missing `glob` and a `source` key: a source on a pattern is no longer a key.
