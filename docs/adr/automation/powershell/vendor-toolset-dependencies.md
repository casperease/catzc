# ADR: Vendor toolset dependencies

## Rules: ADR-AUTO-VENDOR

### Rule ADR-AUTO-VENDOR:1

Vendor modules into `automation/.vendor/<ModuleName>/<Version>/`; the version folder fixes the load path and makes upgrades visible in
diffs.

- [Vendoring solves all three](#vendoring-solves-all-three)

### Rule ADR-AUTO-VENDOR:2

Check vendored modules into git so the repository alone guarantees reproducibility with no restore step.

- [Vendoring solves all three](#vendoring-solves-all-three)
- [How this is enforced](#how-this-is-enforced)

### Rule ADR-AUTO-VENDOR:3

Add new modules only with `Install-VendorModule` (in `Catzc.Base.Vendor`), which downloads from the configured source into the correct
structure; commit the result.

- [How this is enforced](#how-this-is-enforced)

### Rule ADR-AUTO-VENDOR:4

Upgrade deliberately: remove the old version folder, run `Install-VendorModule` for the new version, run tests, then commit. Never
auto-upgrade.

- [Vendoring solves all three](#vendoring-solves-all-three)

### Rule ADR-AUTO-VENDOR:5

Lazy-load expensive modules (Pester, PSScriptAnalyzer) via the `Lazy` parameter in `Import-VendorModules` so they do not slow shell startup.

- [How this is enforced](#how-this-is-enforced)

### Rule ADR-AUTO-VENDOR:6

The vendor source is configurable in `vendor.yml` (`source`, default `PSGallery`; optional `sourceUrl` for a custom feed). Remove vendored
modules only with `Remove-VendorModules`, which refuses to delete anything the source cannot restore — so the committed set stays
reproducible.

- [How this is enforced](#how-this-is-enforced)

## Context

PowerShell modules from the gallery change without notice. A `2.x` version that worked yesterday can behave differently today because the
gallery resolved a different patch version on a different machine. This causes three problems:

1. **Non-determinism.** Two developers running `Install-Module` on the same day can get different versions. CI machines that rebuild images
   get whatever version is current at image-build time. Bugs that only reproduce on one machine are almost always version skew.

2. **Slow startup.** `Install-Module` checks the gallery on every call. Even when the module is already installed, the network round-trip
   adds seconds. In an interactive shell that loads on every new tab, this adds up fast. Gallery outages turn slow into broken.

3. **Implicit dependency chain.** Modules from the gallery can pull in transitive dependencies. You install one module and get five. Any of
   those five can change independently, and any can conflict with another module in your session.

### Vendoring solves all three

Vendoring means checking the module's files directly into the repository under `automation/.vendor/<ModuleName>/<Version>/`. The module
loads from disk with no network call, no version resolution, and no surprises.

- **Deterministic.** Every developer and every CI run uses exactly the same files. The version is locked by the commit, not by a gallery
  query.

- **Fast.** Loading from disk is sub-second. No network, no `Install-Module`, no `Find-Module`. Modules that are expensive to import
  (Pester, PSScriptAnalyzer) can be deferred with the `Lazy` parameter and only loaded on first use.

- **Explicit.** The `.vendor` folder is visible in the repository. You can see exactly which modules are vendored, at which versions.
  Upgrading is a conscious decision: delete the old folder, add the new one, commit.

### Exception: Az PowerShell modules

The Azure PowerShell modules (`Az.*`) are not vendored. They are too large (hundreds of megabytes), update frequently with Azure API
changes, and carry .NET assembly dependencies that conflict when multiple versions coexist in-process. Vendoring them would bloat the
repository and create assembly-loading issues.

See [ADR: prefer-az-cli](prefer-az-cli.md) for how we handle Azure operations without depending on Az modules.

## Decision

All PowerShell module dependencies used by the toolset are vendored in `automation/.vendor/`. Az PowerShell modules are excluded.

### How this is enforced

- **`Catzc.Base.Vendor`** — owns the vendored-module lifecycle. `Install-VendorModule` is the only supported way to add one: it downloads
  with `Save-PSResource` from the configured source (`vendor.yml` — the PowerShell Gallery by default, or a custom feed) into the correct
  `automation/.vendor/<Name>/<Version>/` structure. `Remove-VendorModules` deletes only after `Assert-VendorModuleAvailable` confirms the
  source can restore each target, so removal is always reversible. It uses the bundled `Microsoft.PowerShell.PSResourceGet` (PowerShell
  7.4+), not a vendored dependency of its own.
- **`Import-VendorModules`** — the internal, pre-module-system loader (`Catzc.Internal.Vendor`) the importer runs before any module exists.
  Loads only from the `.vendor` directory; system-installed versions are removed from `$env:PSModulePath` to prevent auto-loading from
  outside the vendor folder.
- **Git** — vendored modules are checked in. Version changes are visible as diffs in pull requests.

## Consequences

- Repository size increases by the size of vendored modules. In practice this is small (Pester, PSScriptAnalyzer, powershell-yaml total ~15
  MB).
- No network dependency for module loading. The toolset works offline and in air-gapped environments.
- Module upgrades show up as explicit diffs in pull requests, making version changes reviewable.
- Az modules must be managed through other mechanisms (system install, workstation provisioning, CI image) — see the prefer-az-cli ADR.

## Dora explains

DORA research shows that vendored dependencies and version pinning reduce deployment variability and enable reproducible builds. Checking
modules into git guarantees every developer and CI run uses identical code, eliminating version-skew bugs and network brittleness.

- [Flexible infrastructure](https://dora.dev/capabilities/flexible-infrastructure/) — eliminates network dependency, enables offline work.
- [Deployment automation](https://dora.dev/capabilities/deployment-automation/) — version pinning and explicit diffs prevent version-skew
  surprises.
- [Continuous delivery](https://dora.dev/capabilities/continuous-delivery/) — fast disk loading and no version skew accelerate cycles.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.
