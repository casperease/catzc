---
catzc:
  derived:
    path: docs/references/automation/internal/index.md
    folder: docs/references/automation/internal
    name: index
    filetype: md
    kind: reference
    language: markdown
    track: docs
    body_sha: "552fcd9f3460"
    adrs:
      - ADR-PWSH-USEPS#2
    links:
      - docs/adr/automation/BCL/native-csharp-types.md
      - docs/adr/automation/caching.md
      - docs/adr/principles/one-living-version.md
      - docs/adr/pwsh/use-ps1-not-psm1.md
      - docs/references/automation/BCL/index.md
      - docs/references/automation/index.md
      - docs/references/automation/internal/catzc-internal-bootstrap.md
      - docs/references/automation/internal/catzc-internal-importer.md
      - docs/references/automation/internal/catzc-internal-loader.md
      - docs/references/automation/internal/catzc-internal-testkit.md
      - docs/references/automation/internal/catzc-internal-types.md
      - docs/references/automation/internal/catzc-internal-vendor.md
---

# Internal (.psm1 shared infrastructure) — automation reference

`.internal` is the home of the loader and the shared libraries, under `automation/.internal/`. It holds the sanctioned `.psm1` modules that
run the toolset's import sequence and the code that BOTH the pre-module bootstrap (which runs before any `Catzc` module exists) and the
post-import `Catzc` modules (which run after) must call — the single home for what would otherwise be duplicated across those two layers
(see [one-living-version](../../../adr/principles/one-living-version.md)). Everything under `automation/*` is documented per module in the
[module reference](../index.md); this area documents the infrastructure those modules are loaded by and never see.

These are `.psm1` files on purpose. The repository's function files are `.ps1` so they share one module scope with no import ceremony; the
`automation/.internal/*.psm1` shared modules are the explicit, sanctioned exception — genuine standalone modules with their own scope,
listed by name in [use-ps1-not-psm1 rule ADR-PWSH-USEPS#2](../../../adr/pwsh/use-ps1-not-psm1.md). They carry no `types/`, generate no
`README.md`, and are excluded from the module list because they are not automation modules — they are what loads them.

## The load sequence

The generated `importer.ps1` shim sets `$env:RepositoryRoot`, imports the **Loader** unconditionally, and delegates the entire load body to
`Invoke-Importer` in the **Importer** overlay. That body loads the remaining shared modules (**Bootstrap**, **Types**, **Vendor**), then the
vendored dependencies, then every `automation/*` module — compiling the combined C# type assembly once before any module's functions — and
finishes with the post-import janitors. Two lifetimes fall out of this:

- **Transient** — removed once import finishes: the **Importer** overlay (the shim removes it after `Invoke-Importer` returns) and
  **Bootstrap** (removed at the tail of `Invoke-Importer`). Their functions are import-time orchestration and must not linger in the
  session.
- **Resident** — kept in the session so a post-import `Catzc` cover function can re-load the same shared code and delegate to it: the
  **Loader**, **Types**, and **Vendor**. **TestKit** is resident-but-on-demand — the importer never loads it; a test does.

## The modules

Listed in load order.

| Module                                                  | In one line                                                                                                             | Lifetime  |
| ------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------- | --------- |
| [Catzc.Internal.Loader](catzc-internal-loader.md)       | The always-loaded entry point — `Import-InternalModule` loads the rest on demand; `Test-IsRunningInPipeline` detects CI | Resident  |
| [Catzc.Internal.Importer](catzc-internal-importer.md)   | The importer overlay — `Invoke-Importer` is the single living copy of the load sequence                                 | Transient |
| [Catzc.Internal.Bootstrap](catzc-internal-bootstrap.md) | Module discovery, manifest generation, C# type compile/load, and the name-collision guard                               | Transient |
| [Catzc.Internal.Vendor](catzc-internal-vendor.md)       | The vendored-module loader shared by the importer and `Catzc.Base.Vendor`                                               | Resident  |
| [Catzc.Internal.Types](catzc-internal-types.md)         | The one combined C# type-source hash both the loader and the cache janitor agree on                                     | Resident  |
| [Catzc.Internal.TestKit](catzc-internal-testkit.md)     | An on-demand Pester fixture library — synthetic repository roots and module folders                                     | On-demand |

## Related

- ADR: [use-ps1-not-psm1](../../../adr/pwsh/use-ps1-not-psm1.md) — why these are the only sanctioned `.psm1` files.
- ADR: [one-living-version](../../../adr/principles/one-living-version.md) — why the two-layer shared code lives here once.
- ADR: [native-csharp-types](../../../adr/automation/BCL/native-csharp-types.md) and [caching](../../../adr/automation/caching.md) — the
  combined type assembly and its committed prebuild that Bootstrap and Types implement.
- Reference: the [BCL area](../BCL/index.md) — the C# type system these loaders compile and load.
