# The BCL type system

The automation platform compiles every module's `types/*.cs` sources into **one** combined assembly for the whole repository, loaded at
import before any module's functions. A type in any module can therefore reference a type in any other; the layering is governed by the
module dependency graph rather than by the compiler. The full contract — the single combined assembly, `namespace = module`, the hash-keyed
committed prebuild, and the cache-state behaviour — is the [native-csharp-types](../../../adr/automation/BCL/native-csharp-types.md) ADR.

## What lives here

- **`DictionaryRecord`** — the shared base for dictionary-compatible data records, in [`Catzc.Base.Objects`](../catzc-base-objects.md). It
  supplies a dictionary view over a record's own public properties and the protected extraction helpers derived records use.
- **Type-accelerator aliases** — a type may publish a short `[Catzc.*]` accelerator, registered after the assembly loads, so
  `[Catzc.Module.X]` resolves at the call site.
- **The IDE project** — [`Catzc.Base.TypesSystem`](../catzc-base-typessystem.md) drives the editor-facing `dotnet build` of the
  `Catzc.Types` project, which mirrors what `Add-Type` compiles at runtime.

## Related

- ADR: [native-csharp-types](../../../adr/automation/BCL/native-csharp-types.md)
- ADR: [caching](../../../adr/automation/caching.md#rule-adr-auto-cache8) — the committed compiled-type prebuild.
