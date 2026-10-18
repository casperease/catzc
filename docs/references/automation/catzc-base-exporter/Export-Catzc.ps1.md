# automation/Catzc.Base.Exporter/Export-Catzc.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Exports catzc — builds it (Build-Modules), then installs it beside a working root or packs it for Install-PSResource.

### description

The top-level export ([ADR-AUTO-BUNDLE#6](../../../adr/automation/platform-bundle.md#rule-adr-auto-bundle6)). It builds with Build-Modules
(exporter.yml defaults; the build parameters pass through) and delivers the build:

- disk (default): the two-part install to -Root (Install-Catzc) — the build under `<Root>/.vendor/Catzc/<version>/` and a root importer.ps1
  that enters it with `<Root>` as the working root;
- nuget: the build folder packed with Compress-PSResource into `<Get-OutputRoot>/automation/packages/`, for a client to register as a local
  PSResource repository and Install-PSResource Catzc. Publishing beyond the local disk is the release workflow's act, never this function's.

### parameter Root

The destination working root of a disk export (where the root importer.ps1 goes).

### parameter To

disk (default) or nuget.

### parameter Bundle

The bundle to build (an exporter.yml bundles key; see Build-Modules). Defaults to default_bundle.

### parameter Module

Module names to build (see Build-Modules).

### parameter ModuleProfile

A profiles.yml key to build (see Build-Modules).

### parameter VendorPolicy

runtime | full (see Build-Modules).

### parameter Version

'auto' (default) or an explicit MAJOR.MINOR.PATCH (see Resolve-CatzcBuildVersion).

### parameter Force

Re-copy the build on a disk install even when the target is already current.

### parameter Silent

Suppress the build, install and pack summaries.

### example 1

```powershell
Export-Catzc -Root C:\work\project        # build + install into C:\work\project\.vendor, importer at the root
```

### example 2

```powershell
Export-Catzc -To nuget                     # build + pack into out/automation/packages/
```
