<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.Exporter/private/New-CatzcNuGetPackage.ps1
    folder: private
    name: new-catzc-nu-get-package
    filetype: ps1
    role: function
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.Exporter
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    test: pwsh/Catzc.Base.Exporter/tests/New-CatzcNuGetPackage.Tests.ps1
    docs: "[New-CatzcNuGetPackage.ps1.md](docs/references/pwsh/catzc-base-exporter/private/New-CatzcNuGetPackage.ps1.md)"
    cites:
      - ADR-AUTO-BUNDLE-TWOARTIFACTINSTALL
      - ADR-GH-RELEASE
---
#>

function New-CatzcNuGetPackage {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory)]
        [string] $Source,

        [Parameter(Mandatory)]
        [string] $DestinationPath
    )

    Assert-PathExist $Source -PathType Container
    $manifestPath = Join-Path $Source 'Catzc.psd1'
    Assert-PathExist $manifestPath -PathType Leaf
    $version = "$((Import-PowerShellDataFile -Path $manifestPath).ModuleVersion)"

    # The public surface: every inner module's FunctionsToExport (the package's own manifest only loads them).
    $functionCount = 0
    foreach ($moduleDir in [System.IO.Directory]::EnumerateDirectories($Source)) {
        $name = [System.IO.Path]::GetFileName($moduleDir)
        $moduleManifest = [System.IO.Path]::Combine($moduleDir, "$name.psd1")
        if (-not $name.StartsWith('.') -and [System.IO.File]::Exists($moduleManifest)) {
            $exports = (Import-PowerShellDataFile -Path $moduleManifest)['FunctionsToExport']
            $functionCount += @($exports | Where-Object { $_ }).Count
        }
    }

    [System.IO.Directory]::CreateDirectory($DestinationPath) | Out-Null
    Compress-PSResource -Path $Source -DestinationPath $DestinationPath

    [pscustomobject]@{
        NuPkg         = Join-Path $DestinationPath "Catzc.$version.nupkg"
        Version       = $version
        Manifest      = $manifestPath
        ModulePath    = $Source
        FunctionCount = $functionCount
    }
}
