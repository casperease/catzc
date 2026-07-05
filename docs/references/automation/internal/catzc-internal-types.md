# Catzc.Internal.Types

The single implementation of the combined C# type-source hash. Its one export, `Get-CombinedTypeHash`, enumerates, orders, and hashes every
module's `types/*.cs` exactly the way the committed `automation/.compiled/Catzc.Types.<hash>.dll` is keyed. It lives in `.internal` because
two layers must agree on that hash byte-for-byte — the **loader** ([`Import-CSharpTypes`](catzc-internal-bootstrap.md), which builds and
keys the DLL) and the **cache janitor** (`Clear-ModuleTypeCache`, a `Catzc` module, which decides which DLLs to keep). The algorithm used to
be copied into both and mirrored again in tests, with a standing "keep them identical" note; it now lives here once and both call it through
`Import-InternalModule Types` (see [one-living-version](../../../adr/principles/one-living-version.md)). It is **resident** — kept in the
session, not removed with the bootstrap.

## What it does

`Get-CombinedTypeHash` takes the automation root and returns, for every non-dot module's `types/*.cs`:

- **`CombinedHash`** — the 8-character lowercase hash that names the DLL (`Catzc.Types.<hash>.dll`), or `$null` when no module ships a C#
  type source;
- **`Snapshot`** — an ordered map of `"<module>/<bare type>"` to that file's per-file digest;
- **`Files`** — the ordinally-sorted source list the caller validates and compiles.

Two properties make the key stable and honest. The hash is **EOL-insensitive** — every `CR` byte is stripped before each file's digest — so
a CRLF vs LF working tree (a `git core.autocrlf` setting, an editor's format-on-save) keys the same DLL on every machine and never re-keys
on a pure line-ending flip. And it **folds in each file's `<module>|<bare type>`**, so moving a `.cs` between modules or renaming it re-keys
the assembly even when the content is byte-identical. Ordering is deterministic and culture-independent (an ordinal comparer, not the
culture-aware `Sort-Object`).

What it deliberately does **not** do is validate namespaces or reject dotted filenames — those are the loader's poka-yokes, kept out of the
shared enumerator on purpose, because the janitor must never throw on a bad source. The full contract of the combined assembly and its
committed prebuild is the [native-csharp-types](../../../adr/automation/BCL/native-csharp-types.md) ADR and the
[BCL type-system reference](../BCL/types-system.md).

## Functions

- `Get-CombinedTypeHash` — the one combined C# type-source hash (with the per-file snapshot and the ordered source list) that both the
  loader and the cache janitor key the committed `Catzc.Types.<hash>.dll` off.

## Related

- ADR: [native-csharp-types](../../../adr/automation/BCL/native-csharp-types.md) — the single combined assembly and its hash key.
- ADR: [caching](../../../adr/automation/caching.md) — the committed compiled-type prebuild this hash names.
- ADR: [one-living-version](../../../adr/principles/one-living-version.md) — why the algorithm lives here once.
- Reference: [Catzc.Internal.Bootstrap](catzc-internal-bootstrap.md) — the loader (`Import-CSharpTypes`) that consumes this hash;
  [Catzc.Base.TypesSystem](../catzc-base-typessystem.md) — the module whose `Clear-ModuleTypeCache` janitor also calls it; the
  [BCL type-system reference](../BCL/types-system.md) and the [internal area overview](index.md).
