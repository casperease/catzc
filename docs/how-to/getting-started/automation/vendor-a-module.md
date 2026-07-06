# Vendor a module

Third-party PowerShell modules are **vendored** — checked into `automation/.vendor/<Name>/<Version>/` — so the repository alone guarantees
reproducibility with no restore step and no PowerShell Gallery call at runtime. Adding one is a single command run at authoring time, then a
commit. The rationale is in [vendor-toolset-dependencies](../../../adr/automation/powershell/vendor-toolset-dependencies.md).

## Add a vendored module

Run this in a **fresh** PowerShell session (a session that has already loaded the module would lock its files):

```powershell
. ./importer.ps1
Install-VendorModule powershell-yaml                       # latest
Install-VendorModule Pester -RequiredVersion 5.7.1         # pinned version
```

`Install-VendorModule` downloads from the Gallery into `automation/.vendor/<Name>/<Version>/`, trims legacy .NET-Framework target folders
(keeping the .NET 6+ assemblies), and logs where it landed. Then **commit the result** — the vendored files are part of the repo, and the
version change shows up as a reviewable diff.

## Currently vendored

```text
automation/.vendor/
  Pester/                 lazy-loaded (test runner)
  PSScriptAnalyzer/       lazy-loaded (linter)
  powershell-yaml/        loaded at import (YAML parsing)
```

Pester and PSScriptAnalyzer are **lazy-loaded** by the importer (`Import-VendorModules -Lazy 'Pester', 'PSScriptAnalyzer'`) so they don't
slow shell startup — they auto-load on first use.

## Upgrade a vendored module

Upgrade deliberately, never automatically:

1. Delete the old version folder: `automation/.vendor/<Name>/<oldVersion>/`.
2. `Install-VendorModule <Name> -RequiredVersion <newVersion>` in a fresh session.
3. `. ./importer.ps1` and `Test-Automation -Level 2` to confirm nothing broke.
4. Commit the deletion + addition together.

## What is not vendored

The Azure **`Az` PowerShell modules** are deliberately not vendored — they are hundreds of megabytes and their assembly dependencies
conflict in-process. Azure operations go through the `az` CLI instead (see
[prefer-az-cli](../../../adr/automation/powershell/prefer-az-cli.md)). System CLI tools (Python, .NET, Terraform, …) aren't vendored either
— they're version-locked and installed by package manager (see [Add a CLI tool](add-a-cli-tool.md)).

## How vendored modules win

The importer strips each vendored module's folder from `$env:PSModulePath` and unloads any non-vendored copy before importing the vendored
one, so the version you committed always wins over a system- or profile-installed copy. That is why the toolset behaves identically on every
machine and in CI, offline, with no Gallery access.
