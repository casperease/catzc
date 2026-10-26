# pwsh/Base.Vendor/Install-VendorModule.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

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

## comment:1

Above `$moduleDir = Join-Path $vendorRoot $Name`, written with `#`.

```text
Only what loads is kept: .NET Framework builds and the analyzer's compatibility profiles are never read on
PowerShell 7.
```

## comment:2

Above `$unusedFolders = @(Get-ChildPath $moduleDir -Directory -Depth 5 -Exclude @()...`, written with `#`.

```text
A vendored module's folders reach three levels below the module folder; the walk must enter every one, vendor
included.
```
