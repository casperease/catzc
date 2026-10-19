# automation/pwsh/Catzc.Base.Vendor/Install-VendorModule.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Saves a PowerShell module into the automation/pwsh/.vendor directory from the configured source.

### description

Downloads with Save-PSResource from the vendor source (configs/vendor.yml — PSGallery by default, or a custom feed) into
`automation/pwsh/.vendor/<Name>/<Version>/`, then removes folders the toolset never loads (legacy .NET Framework builds, PSScriptAnalyzer's
compatibility_profiles). The only supported way to add a vendor module
([ADR-PWSH-VENDOR](../../../adr/automation/pwsh/vendor-toolset-dependencies.md)); commit the result. Must be run in a fresh session — a loaded module
may lock its files. Writes into the source tree's .vendor, so it stops with a named error in build mode (Assert-SourceTree,
[ADR-DSGN-RUNMODE](../../../adr/design/run-modes.md)).

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

## comment:1

Above `$moduleDir = Join-Path $vendorRoot $Name`, written with `#`.

```text
Prune folders the toolset never loads: legacy .NET Framework builds (we only target PS 7+ / .NET 6+) and
PSScriptAnalyzer's ~280 MB compatibility_profiles, read only by the PSUseCompatible* rules that
PSScriptAnalyzerSettings.psd1 keeps off
([ADR-PWSH-VENDOR-ONLYWHATLOADS](/docs/adr/automation/pwsh/vendor-toolset-dependencies.md#rule-adr-pwsh-vendor-onlywhatloads)).
```
