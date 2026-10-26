# pwsh/Base.Vendor/Install-VendorModule.ps1

The one way a vendor module enters the repository: it saves the module from the configured source into `pwsh/.vendor/` and keeps only what
loads on PowerShell 7.

## help

### synopsis

Saves a PowerShell module into the pwsh/.vendor directory from the configured source.

### description

Downloads with Save-PSResource from the vendor source (configs/vendor.yml — PSGallery by default, or a custom feed) into
`pwsh/.vendor/<Name>/<Version>/`, then removes folders the toolset never loads (legacy .NET Framework builds, PSScriptAnalyzer's
compatibility_profiles). The only supported way to add a vendor module
([ADR-PWSH-VENDOR](../../../drs/automation/pwsh/vendor-toolset-dependencies.md)); commit the result. Must be run in a fresh session — a
loaded module may lock its files. Writes into the source tree's .vendor, so it stops with a named error in build mode (Assert-SourceTree,
[DDR-RUNMODE](../../../drs/design/run-modes.md)).

### parameter `Name`

The module name to install from the vendor source.

### parameter `RequiredVersion`

An optional specific version to install. Installs the latest if omitted.

### example 1

```powershell
Install-VendorModule 'Pester'
```

### example 2

```powershell
Install-VendorModule 'Pester' -RequiredVersion '5.5.0'
```

## Pruning after download

After the download, the command deletes the folders the toolset never loads
([ADR-PWSH-VENDOR-ONLYWHATLOADS](../../../drs/automation/pwsh/vendor-toolset-dependencies.md#rule-adr-pwsh-vendor-onlywhatloads)): the .NET
Framework builds (`net20` to `net48`), since catzc targets PowerShell 7 on .NET 6 and later, and PSScriptAnalyzer's roughly 280 MB of
`compatibility_profiles`. Only the `PSUseCompatible*` rules read those profiles, and `PSScriptAnalyzerSettings.psd1` turns those rules off.

The walk that finds them is bounded but deep enough: a vendored module's folders reach three levels below the module folder, so the walk
enters every one, `vendor` folders included, and a folder inside one already removed goes with it.
