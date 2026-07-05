# Catzc.Internal.Loader

The always-loaded entry point for `.internal` shared code. It is the one thing the generated `importer.ps1` shim imports unconditionally,
and — unlike the transient bootstrap and importer overlay — it **stays in the session** for the whole life of the shell. Its single export,
`Import-InternalModule`, is how every other `.internal` shared module is loaded: by the importer during startup, and by a post-import
`Catzc` cover function that needs to reach the same shared code afterward.

## What it does

The `.internal` folder holds code that both layers of the toolset must call — the pre-module **bootstrap** (which runs before any `Catzc`
module exists) and the **`Catzc` modules** (which run after). Rather than duplicate that code across the two layers, it lives once under
`.internal` and both sides load it through this loader (see [one-living-version](../../../adr/principles/one-living-version.md)). Because
the loader itself is what provides `Import-InternalModule`, it cannot bootstrap itself — so the shim imports it directly, first, and never
removes it. A resident cover function on a hot path can therefore call `Import-InternalModule Types` (or `Vendor`) and delegate, paying
nothing when the shared module is already loaded.

`Import-InternalModule` is **idempotent**: it takes the bare area name of a shared module — `Types` resolves to
`.internal/Catzc.Internal.Types.psm1` — and is a no-op when that module is already loaded, so the guard on a cover function's hot path costs
nothing. Its `-Force` switch reloads even when already present; the importer passes it on its own initial load so a devbox re-import (the
cache ADR's invalidation boundary) picks up edits to a shared module, the same "re-run the importer to invalidate" contract the C# type
cache follows.

## Functions

- `Import-InternalModule` — load a `.internal` shared module once into the global session by bare area name (`Types`, `Vendor`, `Bootstrap`,
  `TestKit`); idempotent, with `-Force` to reload across the re-import invalidation boundary.

## Related

- ADR: [one-living-version](../../../adr/principles/one-living-version.md) — the two-layer shared code this loader exists to serve.
- ADR: [use-ps1-not-psm1](../../../adr/automation/powershell/use-ps1-not-psm1.md) — the loader is a sanctioned `.psm1`, not a function file.
- ADR: [caching](../../../adr/automation/caching.md) — the re-import invalidation boundary `-Force` honours.
- Reference: the [internal area overview](index.md) and the shared modules it loads — [Types](catzc-internal-types.md),
  [Vendor](catzc-internal-vendor.md), [Bootstrap](catzc-internal-bootstrap.md), [TestKit](catzc-internal-testkit.md).
