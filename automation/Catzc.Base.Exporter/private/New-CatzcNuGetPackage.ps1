<#
.SYNOPSIS
    Packs a Catzc build into a NuGet package (.nupkg) for a local-path Install-PSResource.
.DESCRIPTION
    The package delivery shape (ADR-AUTO-BUNDLE:6). The build folder is already an installable module — its
    Catzc.psd1 carries the version, GUID and package metadata, its Catzc.psm1 loads the platform, and the
    vendored dependencies ride inside its .vendor/ — so the build folder itself is compressed, as is, with
    Compress-PSResource into <DestinationPath>/Catzc.<version>.nupkg (pack only, no publish). A client registers
    the destination folder as a PSResource repository and runs Install-PSResource Catzc. Publishing beyond the
    local disk is the release workflow's act (docs/adr/github/github-release.md).
.PARAMETER Source
    The build root (Build-Modules' BuildRoot — the Catzc/<version>/ folder).
.PARAMETER DestinationPath
    The directory the .nupkg is written into.
.OUTPUTS
    [pscustomobject] with NuPkg, Version (from Catzc.psd1), Manifest (the build's Catzc.psd1), ModulePath (the
    build root), and FunctionCount (the public functions the build's modules export).
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
