---
catzc:
  derived:
    path: docs/references/automation/catzc-base-exporter/configs/exporter.yml.md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: cf39253df0a8
---

# automation/Catzc.Base.Exporter/configs/exporter.yml

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `direct_install_version: 6.6.666`, written with `#`.

```text
The single config for how this repository exports itself as the installable, versioned Catzc build.

Build-Modules / Export-Catzc read their defaults from here (Get-Config -Config exporter); explicit params
override for ad-hoc builds. Because every read routes through the Get-Config / Resolve-ConfigEntry seam,
Pester tests swap in a fixture exporter.yml to vary these options without touching the shipped config — the
repo keeps exactly one real export config. Validated on load by the ExporterConfig type.
See [ADR-AUTO-BUNDLE](/docs/adr/automation/platform-bundle.md).
```

## comment:2

Above `direct_install_version: 6.6.666`, written with `#`.

```text
direct_install_version — the numeric MAJOR.MINOR.PATCH placeholder every devbox build carries
(out/automation/built/<bundle>/Catzc/<v>/); obviously not a real number, and a rebuild overwrites it in place. A
pipeline build never uses it (Resolve-CatzcBuildVersion).
```

## comment:3

Above `bundles:`, written with `#`.

```text
The named bundles. Each is a release identity of its own — this is a mono repo, so every bundle versions on its
own and no bundle's version moves another's:
  profile        — the module set (a profiles.yml key), closure-expanded by the build
  version        — numeric MAJOR.MINOR of a pipeline build of this bundle; its PATCH is the first-parent commit
                   count of the built commit, so the same commit always gets the same version
  vendor_policy  — runtime (the default) ships only the runtime-required vendored module (powershell-yaml); full
                   also ships Pester/PSScriptAnalyzer for a bundle that runs tests
  max_files,     — optional footprint limits: Build-Modules fails a build that holds more files or bytes. A bundle
  max_bytes        is an engine carried to other environments, so its size is checked, not hoped for. The limits
                   below leave about 20% headroom over the builds of 2026-10-15 (full 393 files / 5.6 MB, azure 380
                   / 5.5 MB, minimal 239 / 2.4 MB); raise one in a reviewed edit when a bundle legitimately grows.
A build lands in out/automation/built/<bundle>/Catzc/<version>/. default_bundle is built when none is named.
```

## comment:4

Above `module_guid: 211b36c7-f7eb-4f3c-93f5-9132b535fa56`, written with `#`.

```text
Package identity and metadata — Build-Modules hands these to the build engine, which writes them into the
build's top-level Catzc.psd1 (the manifest Install-PSResource and the PowerShell Gallery read). module_guid is
the module's stable identity across versions (a registered managed GUID, [ADR-AUTO-GUIDS](/docs/adr/automation/managed-guids.md)).
```
