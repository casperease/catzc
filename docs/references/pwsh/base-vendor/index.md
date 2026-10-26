# Catzc.Base.Vendor

Owns the vendored third-party PowerShell modules under `pwsh/.vendor/` — adding them, removing them, and proving they can be restored from
the network. Vendoring checks each dependency's exact version straight into the repository so a load needs no gallery query (deterministic,
fast, offline; see [vendor-toolset-dependencies](../../../drs/automation/pwsh/vendor-toolset-dependencies.md)); this module is the lifecycle
around that committed set. It deliberately does **not** load them at import time — that is the internal, pre-module-system loader
(`Import-VendorModules`); this module is the post-import surface for managing what is committed. Every operation targets a configured source
(`vendor.yml` — the PowerShell Gallery by default, a custom feed when set), reached through the bundled `Microsoft.PowerShell.PSResourceGet`
(shipped with PowerShell 7.4+).

## Responsibilities

| Responsibility   | Area          | Name                                                                     |
| ---------------- | ------------- | ------------------------------------------------------------------------ |
| responsibility:1 | lifecycle     | [Vendored-module lifecycle](#responsibility1--vendored-module-lifecycle) |
| responsibility:2 | restorability | [Source restorability](#responsibility2--source-restorability)           |
| responsibility:3 | source        | [Source configuration](#responsibility3--source-configuration)           |

### responsibility:1 — Vendored-module lifecycle

Adding a module to the committed vendor set and removing modules from it. Adding downloads an exact version from the source into the
`pwsh/.vendor/<Name>/<Version>/` layout the loader expects and strips the legacy .NET Framework folders a PowerShell 7 toolset never uses;
it is the only supported way to introduce a vendored dependency, and the result is committed. Removal is guarded: it never deletes a module
the source cannot restore (responsibility:2), and defaults to a dry run — it reports what would go and the exact command to recreate it,
deleting only when explicitly armed.

### responsibility:2 — Source restorability

Proving that a committed vendored module is obtainable from the configured source, in a throwing and a querying form. This is the safety
behind removal and the standalone validation that a vendored set is reproducible: because the repository is the source of truth for the
locked version, a module may only be deleted once the network is confirmed able to hand it back. A pull request that strips vendored
binaries to slim the repository runs this check first.

### responsibility:3 — Source configuration

The single source setting the other responsibilities resolve against — which registered repository to download from and validate against. It
defaults to the PowerShell Gallery and needs no url; a custom feed (an Artifactory or proxy) is named by an optional url that is registered
as a trusted repository on first use. The default is deliberately the only value the shipped config carries — a custom feed is an override,
undefined until a consumer sets it.

## What the module does

The three responsibilities are one pipeline over a single configured source. Source configuration resolves `vendor.yml` to a repository name
(the Gallery, or a custom feed registered on demand); the lifecycle installs and removes against that repository; and restorability is the
gate between them — the check that turns an irreversible delete into a safe one. The through-line is that the committed `.vendor/` tree, not
the network, is the source of truth: installing writes an exact version into the tree to be committed, and removing refuses to touch
anything the network cannot give back, so the tree is always reconstructable.

The module sits above [Catzc.Base.Config](../base-config/index.md) (for `vendor.yml`), [Catzc.Base.Repository](../base-repository/index.md) (to
anchor the vendor root), and [Catzc.Base.Writers](../base-writers/index.md) (for its reporting), and it leans on the bundled
`Microsoft.PowerShell.PSResourceGet` rather than adding a vendored dependency of its own. It is the post-import counterpart to the internal
`Import-VendorModules` loader that the importer runs before any module exists: that one gets the committed modules into the session; this
one governs which modules are committed in the first place.

## Division

The module's public functions and configuration file, sorted into the responsibilities above.

| Responsibility                               | Function                       |
| -------------------------------------------- | ------------------------------ |
| responsibility:1 — Vendored-module lifecycle | `Install-VendorModule`         |
|                                              | `Remove-VendorModules`         |
| responsibility:2 — Source restorability      | `Assert-VendorModuleAvailable` |
|                                              | `Test-VendorModuleAvailable`   |
| responsibility:3 — Source configuration      | `vendor.yml`                   |
