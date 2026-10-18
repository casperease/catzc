# pwsh/.internal/assets/Import-Catzc.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Loads this Catzc build into the session — build mode's entry point.

### description

The initializer of a built Catzc package ([ADR-DSGN-RUNMODE](../../../../adr/design/run-modes.md),
[ADR-AUTO-BUNDLE](../../../../adr/automation/platform-bundle.md)). Authored once under pwsh/.internal/assets/ and copied verbatim into every
build by Invoke-ModuleBuild; the build's Catzc.psm1 dot-sources it, so `Import-Module Catzc` and dot-sourcing this file set up the same
session. Dot-source it (. `<build>/Import-Catzc.ps1`) so its $global:/$env: effects land in the caller's session.

It sets the two roots — CatzcModulesRoot to this build's folder (the code root), RepositoryRoot to -RepositoryRoot, else the value already
set, else the current location (the working root, where out/ and repo-relative paths resolve) — then runs the one living importer in its
-Bundle mode: preferences, the error view, vendored modules, the prebuilt types assembly and its accelerators, then every module's prebuilt
manifest.

### parameter `RepositoryRoot`

The working root. Defaults to the RepositoryRoot already set, else the current location.

### parameter `AllowWarnings`

Set $global:WarningPreference to Continue instead of Stop (warnings do not fail the load).

### example 1

```powershell
. ./out/automation/built/full/Catzc/6.6.666/Import-Catzc.ps1 -RepositoryRoot C:/projects/work
```
