---
catzc:
  derived:
    path: docs/adr/pwsh/vendor-toolset-dependencies.md
    kind: adr
    language: markdown
    track: docs
    body_sha: "6eefb77c0042"
    defines:
      - ADR-PWSH-VENDOR#{1,3-8}
    adrs:
      - ADR-AUTO-DEPM#8
    links:
      - docs/adr/automation/controlling-module-dependencies.md#rule-adr-auto-depm8
      - docs/adr/automation/effective-in-enterprises.md
      - docs/adr/azure/prefer-az-cli.md
      - docs/adr/pwsh/module-path-hygiene.md
      - docs/adr/repository/protected-globs.md
---

# ADR: Vendor toolset dependencies

## Rules: ADR-PWSH-VENDOR

### Rule ADR-PWSH-VENDOR:1

Vendor modules into `automation/.vendor/<ModuleName>/<Version>/`; the version folder fixes the load path and makes upgrades visible in
diffs. This is how a third-party PowerShell module becomes an internal module dependency, vendored and named (ADR-AUTO-DEPM#8).

- [Vendoring solves all three](#vendoring-solves-all-three)

### Rule ADR-PWSH-VENDOR:3

Add new modules only with `Install-VendorModule` (in `Catzc.Base.Vendor`), which downloads from the configured source into the correct
structure; commit the result.

- [How this is enforced](#how-this-is-enforced)

### Rule ADR-PWSH-VENDOR:4

Upgrade deliberately: remove the old version folder, run `Install-VendorModule` for the new version, run tests, then commit. Never
auto-upgrade.

- [Vendoring solves all three](#vendoring-solves-all-three)

### Rule ADR-PWSH-VENDOR:5

Lazy-load expensive modules (Pester, PSScriptAnalyzer) via the `Lazy` parameter in `Import-VendorModules` so they do not slow shell startup.

- [How this is enforced](#how-this-is-enforced)

### Rule ADR-PWSH-VENDOR:6

The vendor source is configurable in `vendor.yml` (`source`, default `PSGallery`; optional `sourceUrl` for a custom feed). Remove vendored
modules only with `Remove-VendorModules`, which refuses to delete anything the source cannot restore — so the committed set stays
reproducible.

- [How this is enforced](#how-this-is-enforced)

### Rule ADR-PWSH-VENDOR:7

A vendored module carries only what the toolset loads. Folders it never loads are pruned at install time by `Install-VendorModule`, never by
hand, so a reinstall or upgrade (ADR-PWSH-VENDOR#4) reproduces the same trimmed copy. A folder comes back only by removing it from the prune
list and reinstalling.

- [Pruned folders](#pruned-folders)
- [How this is enforced](#how-this-is-enforced)

### Rule ADR-PWSH-VENDOR:8

Never call the PowerShell Gallery at runtime. `Install-Module` and `Find-Module` need network and gallery availability; all module
dependencies are vendored, and the gallery (or the configured feed) is reached only when an author runs `Install-VendorModule`.

- [No gallery at runtime](#no-gallery-at-runtime)
- [How this is enforced](#how-this-is-enforced)

## Context

[controlling-module-dependencies](../automation/controlling-module-dependencies.md#rule-adr-auto-depm8) makes every internal module
dependency vendored and named, committed in the tree with nothing to fetch, and
[effective-in-enterprises](../automation/effective-in-enterprises.md) assumes a machine with no network access at runtime. This ADR is how
the PowerShell modules the toolset depends on are vendored.

PowerShell modules from the gallery change without notice. A `2.x` version that worked yesterday can behave differently today because the
gallery resolved a different patch version on a different machine. This causes three problems:

1. **Non-determinism.** Two developers running `Install-Module` on the same day can get different versions. CI machines that rebuild images
   get whatever version is current at image-build time. Bugs that only reproduce on one machine are almost always version skew.

2. **Slow startup.** `Install-Module` checks the gallery on every call. Even when the module is already installed, the network round-trip
   adds seconds. In an interactive shell that loads on every new tab, this adds up fast. Gallery outages turn slow into broken.

3. **Implicit dependency chain.** Modules from the gallery can pull in transitive dependencies. You install one module and get five. Any of
   those five can change independently, and any can conflict with another module in your session.

### Vendoring solves all three

Vendoring means checking the module's files directly into the repository under `automation/.vendor/<ModuleName>/<Version>/`, committed as
every internal dependency is (ADR-AUTO-DEPM#8). The module loads from disk with no network call, no version resolution, and no surprises.

- **Deterministic.** Every developer and every CI run uses exactly the same files. The version is locked by the commit, not by a gallery
  query.

- **Fast.** Loading from disk is sub-second. No network, no `Install-Module`, no `Find-Module`. Modules that are expensive to import
  (Pester, PSScriptAnalyzer) can be deferred with the `Lazy` parameter and only loaded on first use.

- **Explicit.** The `.vendor` folder is visible in the repository. You can see exactly which modules are vendored, at which versions.
  Upgrading is a conscious decision: delete the old folder, add the new one, commit.

### No gallery at runtime

Gallery access may be blocked by a proxy or firewall, or need proxy configuration the machine does not have, and a gallery outage turns a
slow call into a broken one. A runtime `Install-Module` or `Find-Module` would make every load depend on all of that. So the gallery is
reached at authoring time only: `Install-VendorModule` reaches it once, when an author adds or upgrades a module, and the commit carries the
result to every machine.

### The Az PowerShell exception

`Exception: Az PowerShell modules`

The Azure PowerShell modules (`Az.*`) are not vendored. They are too large (hundreds of megabytes), update frequently with Azure API
changes, and carry .NET assembly dependencies that conflict when multiple versions coexist in-process. Vendoring them would bloat the
repository and create assembly-loading issues.

See [ADR: prefer-az-cli](../azure/prefer-az-cli.md) for how we handle Azure operations without depending on Az modules.

### Pruned folders

A gallery package ships content for hosts and features this toolset never uses, and every tracked byte costs on each clone and on every read
of the whole repository: the protection identities hash every tracked file ([protected-globs](../repository/protected-globs.md)). Two kinds
of folder are pruned:

- **Legacy .NET Framework builds** (`net4x` and older). The toolset targets PowerShell 7.4+ on .NET, so it never loads them.
- **PSScriptAnalyzer's `compatibility_profiles`.** About 280 MB of platform profiles, read only by the `PSUseCompatible*` rules, which
  `PSScriptAnalyzerSettings.psd1` keeps off. Bringing those rules back means vendoring the profiles again, and the settings file documents
  that path next to the rules.

## Decision

All PowerShell module dependencies used by the toolset are vendored in `automation/.vendor/`, and nothing calls the gallery at runtime. Az
PowerShell modules are excluded.

### How this is enforced

- **`Catzc.Base.Vendor`** — owns the vendored-module lifecycle. `Install-VendorModule` is the only supported way to add one: it downloads
  with `Save-PSResource` from the configured source (`vendor.yml` — the PowerShell Gallery by default, or a custom feed) into the correct
  `automation/.vendor/<Name>/<Version>/` structure, then prunes the folders the toolset never loads ([Pruned folders](#pruned-folders)). It
  runs at authoring time, never at runtime. `Remove-VendorModules` deletes only after `Assert-VendorModuleAvailable` confirms the source can
  restore each target, so removal is always reversible. It uses the bundled `Microsoft.PowerShell.PSResourceGet` (PowerShell 7.4+), not a
  vendored dependency of its own.
- **`Import-VendorModules`** — the internal, pre-module-system loader (`Catzc.Internal.Vendor`) the importer runs before any module exists.
  Loads only from the `.vendor` directory; system-installed versions are removed from `$env:PSModulePath` to prevent auto-loading from
  outside the vendor folder ([module-path-hygiene](module-path-hygiene.md)).
- **Git** — vendored modules are checked in (ADR-AUTO-DEPM#8). Version changes are visible as diffs in pull requests.

## Consequences

- Repository size increases by the size of the vendored modules, kept small by pruning what the toolset never loads.
- No network dependency for module loading. The toolset works offline and in air-gapped environments, behind firewalls and proxies with no
  gallery access.
- Module upgrades show up as explicit diffs in pull requests, making version changes reviewable.
- Az modules must be managed through other mechanisms (system install, workstation provisioning, CI image) — see the prefer-az-cli ADR.
