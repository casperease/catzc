# pwsh/Base.Config/types/ConfigDefaultDifference.cs

The record of one top-level key whose value in a shipped config file differs from the default its config type declares for it, and the
comparison that finds those keys.

## Comparison

`Compare` returns the keys of a shipped file whose scalar value differs from the type's `Default<Key>` constant, the key in Pascal case. A
key with no such constant, or one whose default is no scalar (a list or a map), compares nothing.
