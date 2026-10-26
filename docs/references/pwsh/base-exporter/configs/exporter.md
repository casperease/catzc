# pwsh/Base.Exporter/configs/exporter.yml

The single config for how this repository exports itself as the installable, versioned Catzc build
([ADR-AUTO-BUNDLE](../../../../drs/automation/platform-bundle.md)). `Build-Modules` and `Export-Catzc` read their defaults from here
(`Get-Config -Config exporter`), and explicit parameters override them for ad-hoc builds.

Every read routes through the `Get-Config` / `Resolve-ConfigEntry` seam, so Pester tests swap in a fixture `exporter.yml` to vary these
options without touching the shipped config; the repository keeps exactly one real export config. The `ExporterConfig` type validates it on
load.

## Keys

- **`direct_install_version`** — the numeric MAJOR.MINOR.PATCH placeholder every devbox build carries
  (`out/automation/built/<bundle>/Catzc/<v>/`). It is obviously not a real number, and a rebuild overwrites it in place. A pipeline build
  never uses it (`Resolve-CatzcBuildVersion`).
- **`bundles`** — the named bundles. See below.
- **`default_bundle`** — the bundle built when none is named.
- **`module_guid`** — the module's stable identity across versions, a registered managed GUID
  ([ADR-AUTO-GUIDS](../../../../drs/automation/managed-guids.md)).
- **`package`** — package identity and metadata. `Build-Modules` hands them to the build engine, which writes them into the build's
  top-level `Catzc.psd1`, the manifest `Install-PSResource` and the PowerShell Gallery read.

## Bundles

Each bundle is a release identity of its own. This is a mono repo, so every bundle versions on its own and no bundle's version moves
another's. A build lands in `out/automation/built/<bundle>/Catzc/<version>/`.

- **`profile`** — the module set (a `profiles.yml` key), closure-expanded by the build.
- **`version`** — the numeric MAJOR.MINOR of a pipeline build of this bundle; its PATCH is the first-parent commit count of the built
  commit, so the same commit always gets the same version.
- **`vendor_policy`** — `runtime` (the default) ships only the runtime-required vendored module (powershell-yaml); `full` also ships Pester
  and PSScriptAnalyzer for a bundle that runs tests.
- **`max_files`** and **`max_bytes`** — optional footprint limits: `Build-Modules` fails a build that holds more files or bytes. A bundle is
  an engine carried to other environments, so its size is checked, not hoped for. The shipped limits leave headroom over the current builds;
  raise one in a reviewed edit when a bundle legitimately grows.
