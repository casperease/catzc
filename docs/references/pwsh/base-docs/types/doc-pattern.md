# pwsh/Base.Docs/types/DocPattern.cs

One glob-based convention from `configs/readme.yml`: every folder matched by `glob` derives the source of its README from `source`, a
template whose `{kebab}` placeholder expands to the matched folder's leaf name rendered in the kebab case of `NameCase`, and whose `{name}`
placeholder expands to the leaf as written. Both are repository-root-relative, '/'-separated communication-form values
([ADR-AUTO-PATH](../../../../drs/automation/path-representation.md)). It mirrors a `readme.yml` patterns entry, snake_case keys.

It derives from `Catzc.Base.Objects.DictionaryRecord`, so an instance also presents as a read-only dictionary over its own properties and
its constructor uses the base's `Req` extraction helper.

## comment:1

Above `public string glob { get; }`, written with `//`.

```text
Repository-relative glob whose matched module folders each receive a generated README. Required. A folder's README source is its
module article, which the comment-pages resolver derives, so a pattern names no source of its own.
```
