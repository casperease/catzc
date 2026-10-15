---
catzc:
  derived:
    path: docs/references/automation/catzc-base-exporter/Build-Modules.ps1.md
    kind: comment-page
    body_sha: "138d5f43cf3a"
    adrs:
      - ADR-AUTO-BUNDLE#1
      - ADR-AUTO-DRYRUN#2
---

# automation/Catzc.Base.Exporter/Build-Modules.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The public entry to the build ([ADR-AUTO-BUNDLE#1](/docs/adr/automation/platform-bundle.md#rule-adr-auto-bundle1)).
It settles the build's inputs from configs/exporter.yml
(Get-Config -Config exporter), hands them to the engine (Invoke-ModuleBuild in Catzc.Internal.Builder), and
verifies what the engine wrote: against the bundle's footprint limits (max_files, max_bytes, when it states them;
a build that overrides the selection or vendor policy is an experiment, not the bundle, and is not measured),
then with Assert-CatzcBundle. A build is a build of one named bundle — exporter.yml
bundles.<name>, a release identity with its own profile, version line and vendor policy:

  bundle        -Bundle, else exporter.yml default_bundle
  modules       the bundle's profile; -Module and/or -ModuleProfile override it for an experiment or a test
                (combinable; the engine closure-expands the union over dependencies.yml)
  version       Resolve-CatzcBuildVersion -Version -Bundle (auto: 6.6.666 on a devbox, the bundle's
                MAJOR.MINOR plus the commit count in a pipeline)
  vendor policy -VendorPolicy, else the bundle's vendor_policy
  destination   -Destination, else <Get-OutputRoot>/automation/built/<bundle>; the build lands in
                <Destination>/Catzc/<version>/, so two bundles never share a folder
  package       exporter.yml module_guid + package.* -> the engine's PackageMetadata for Catzc.psd1

-DryRun returns the engine's plan and writes nothing (so there is nothing to verify). Returns the engine's
result (BuildRoot, Version, Modules, TypesHash, ContentHash, FileCount, Dirty, DryRun).
```

## comment:2

Section `.PARAMETER ModuleProfile` of the comment-based help.

```text
A profiles.yml key whose modules to build (combinable with -Module). Defaults to the bundle's profile when
-Module is not given.
```

## comment:3

Section `.PARAMETER VendorPolicy` of the comment-based help.

```text
runtime ships only powershell-yaml; full also ships Pester and PSScriptAnalyzer (needed by a build run, which runs the
tests against the build). Defaults to the bundle's vendor_policy.
```

## comment:4

Section `.PARAMETER Destination` of the comment-based help.

```text
The parent folder the Catzc/<version>/ build is written under. Defaults to
<Get-OutputRoot>/automation/built/<bundle>.
```

## comment:5

Above `function Build-Modules {`.

```text
Uses -DryRun, not ShouldProcess/-WhatIf — see
[ADR-AUTO-DRYRUN#2](/docs/adr/automation/dry-run.md#rule-adr-auto-dryrun2).
```

## comment:6

Above `[string] $ModuleProfile = $(`.

```text
The bundle's profile, unless -Module names the selection. Read only when the bundle exists; an unknown
bundle is rejected in the body with the list of bundles.
```

## comment:7

Above `Import-InternalModule Builder`.

```text
The engine is an .internal module, loaded on demand and not part of the post-import command set, so it is
invoked by name — which keeps it off the static function-dependency graph (the pattern the bootstrap
helpers use) while still resolving through normal command lookup.
```

## comment:8

Above `$isDeclaredBundle = -not ($PSBoundParameters.ContainsKey('Module') -or...`.

```text
The footprint limits describe the bundle as declared. A build whose selection or vendor policy is overridden
(an experiment, or a test build that adds the test toolset) is not that bundle, so it is not measured
against them.
```
