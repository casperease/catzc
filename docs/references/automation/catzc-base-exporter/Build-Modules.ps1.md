# automation/Catzc.Base.Exporter/Build-Modules.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Builds the selected modules into one installable, versioned Catzc module — build mode's code root.

### description

The public entry to the build ([ADR-AUTO-BUNDLE#1](../../../adr/automation/platform-bundle.md#rule-adr-auto-bundle1)). It settles the
build's inputs from configs/exporter.yml (Get-Config -Config exporter), hands them to the engine (Invoke-ModuleBuild in
Catzc.Internal.Builder), and verifies what the engine wrote: against the bundle's footprint limits (max_files, max_bytes, when it states
them; a build that overrides the selection or vendor policy is an experiment, not the bundle, and is not measured), then with
Assert-CatzcBundle. A build is a build of one named bundle — exporter.yml `bundles.<name>`, a release identity with its own profile, version
line and vendor policy:

```text
bundle        -Bundle, else exporter.yml default_bundle
modules       the bundle's profile; -Module and/or -ModuleProfile override it for an experiment or a test
              (combinable; the engine closure-expands the union over dependencies.yml)
version       Resolve-CatzcBuildVersion -Version -Bundle (auto: 6.6.666 on a devbox, the bundle's
              MAJOR.MINOR plus the commit count in a pipeline)
vendor policy -VendorPolicy, else the bundle's vendor_policy
destination   -Destination, else <Get-OutputRoot>/automation/built/<bundle>; the build lands in
              <Destination>/Catzc/<version>/, so two bundles never share a folder
package       exporter.yml module_guid + package.* -> the engine's PackageMetadata for Catzc.psd1
```

-DryRun returns the engine's plan and writes nothing (so there is nothing to verify). Returns the engine's result (BuildRoot, Version,
Modules, TypesHash, ContentHash, FileCount, Dirty, DryRun).

### parameter Module

Module names to build (closure-expanded by the engine), in place of the bundle's profile.

### parameter Bundle

The bundle to build (an exporter.yml bundles key). Defaults to default_bundle.

### parameter ModuleProfile

A profiles.yml key whose modules to build (combinable with -Module). Defaults to the bundle's profile when -Module is not given. The
bundle's profile, unless -Module names the selection. Read only when the bundle exists; an unknown bundle is rejected in the body with the
list of bundles.

### parameter VendorPolicy

The bundle's vendor policy. runtime ships only powershell-yaml; full also ships Pester and PSScriptAnalyzer (needed by a build run, which
runs the tests against the build). Defaults to the bundle's vendor_policy.

### parameter Version

'auto' (default) or an explicit numeric MAJOR.MINOR.PATCH — see Resolve-CatzcBuildVersion.

### parameter Destination

The parent folder the `Catzc/<version>/` build is written under. Defaults to `<Get-OutputRoot>/automation/built/<bundle>`.

### parameter DryRun

Return the build plan without writing anything.

### parameter Silent

Suppress the local-version notice and the summary line.

### example 1

```powershell
Build-Modules
```

### example 2

```powershell
Build-Modules -Bundle azure
```

### example 3

```powershell
Build-Modules Catzc.Base.Config -DryRun
```

## comment:1

Above `function Build-Modules {`, written with `#`.

```text
Uses -DryRun, not ShouldProcess/-WhatIf — see
[ADR-AUTO-DRYRUN#2](/docs/adr/automation/dry-run.md#rule-adr-auto-dryrun2).
```

## comment:2

Above `Import-InternalModule Builder`, written with `#`.

```text
The engine is an .internal module, loaded on demand and not part of the post-import command set, so it is
invoked by name — which keeps it off the static function-dependency graph (the pattern the bootstrap
helpers use) while still resolving through normal command lookup.
```

## comment:3

Above `$isDeclaredBundle = -not ($PSBoundParameters.ContainsKey('Module') -or...`, written with `#`.

```text
The footprint limits describe the bundle as declared. A build whose selection or vendor policy is overridden
(an experiment, or a test build that adds the test toolset) is not that bundle, so it is not measured
against them.
```
