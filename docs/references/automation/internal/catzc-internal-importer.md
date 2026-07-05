# Catzc.Internal.Importer

The importer overlay — the single living copy of the toolset's whole load sequence. It exports one function, `Invoke-Importer`, whose
parameter block **is** the importer's public switch surface. The root `importer.ps1` is a thin, generated shim (produced by `New-Importer`
in [Catzc.Base.ModuleSystem](../catzc-base-modulesystem.md)) that carries the same parameter block, sets `$env:RepositoryRoot`, and
delegates here — so the committed entry point can never drift from the load logic it delegates to (see
[one-living-version](../../../adr/principles/one-living-version.md)). Like the bootstrap, this overlay is import-time orchestration, not
shared library code: the shim removes it once `Invoke-Importer` returns.

## What it does

`Invoke-Importer` runs the load sequence end to end:

1. **Guardrails** — enforce the PowerShell 7.4+ floor (the vendor loader relies on the bundled `Microsoft.PowerShell.PSResourceGet`, first
   shipped in 7.4), set strict mode, and set the fail-fast error and warning preferences (`-AllowWarnings` relaxes warnings to `Continue`).
2. **Console detection** — walk the call stack to tell a direct console session from a load inside a script, so a console session gets the
   end-of-load timer while a script does not.
3. **Shared modules** — with the Loader already imported by the shim, load [Bootstrap](catzc-internal-bootstrap.md),
   [Types](catzc-internal-types.md), and [Vendor](catzc-internal-vendor.md) (with `-Force`, honouring the re-import invalidation boundary).
4. **Dependencies and modules** — install the custom error view, load the vendored dependencies (`Import-VendorModules`, deferring Pester
   and PSScriptAnalyzer as lazy), optionally wipe the compiled type DLLs first (`-ClearCompiledTypes`), then discover and import every
   `automation/*` module (`Import-AllModules`, which compiles the combined C# type assembly once before any module's functions).
5. **Post-import janitors** — keep the derived artifacts current and the session honest: the type-cache tidy
   (`Clear-ModuleTypeCache`), the generated READMEs (`Build-Readme`), the cSpell dictionaries (`Build-TerminologyDictionary`), the managed
   root config files (`Build-RootConfig`), the session-PATH reconcile (`Sync-SessionTools`), and a Windows warning when
   `PSModulePath` contains a network share. Each is guarded (absent in the bootstrap sandbox) and each is a fast no-op on a clean tree.
6. **Teardown** — remove the transient bootstrap module (kept until here so importer output can route through its `Write-ImporterMessage`),
   leaving the resident Loader, Types, and Vendor in the session, and print the console load timer.

Its parameter block is asserted to match `importer.ps1` — a drift test regenerates the shim from it and compares — so the two can never
diverge. The switches are the toolset's load surface: `-ExportPrivates` (export `private/` functions so tests can reach them),
`-AllowWarnings`, `-DiagnoseLoadTime` (per-stage timings and an end-of-load summary), `-ClearCompiledTypes` (rebuild every C# type from
source), `-NonSilentClear` (surface the type-cache janitor's report), and `-SkipJanitors` (a lean load for a copied subset, e.g.
`Test-InIsolation`).

## Functions

- `Invoke-Importer` — run the toolset's entire load sequence; the single living copy of the importer body that the generated `importer.ps1`
  shim delegates to. Transient — the shim removes this module afterward.

## Related

- ADR: [one-living-version](../../../adr/principles/one-living-version.md) — why the shim is a generated copy of this one body.
- ADR: [use-ps1-not-psm1](../../../adr/automation/powershell/use-ps1-not-psm1.md) — the overlay is a sanctioned `.psm1`.
- Reference: [Catzc.Base.ModuleSystem](../catzc-base-modulesystem.md) — `New-Importer` generates the `importer.ps1` shim from this block;
  [Bootstrap](catzc-internal-bootstrap.md), [Vendor](catzc-internal-vendor.md), and [Types](catzc-internal-types.md) — the shared modules it
  drives; the [internal area overview](index.md).
