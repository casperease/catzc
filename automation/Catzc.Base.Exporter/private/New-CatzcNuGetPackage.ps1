<#
.SYNOPSIS
    Packs a built bundle into a NuGet package (.nupkg) with a PSGallery-compatible module manifest.
.DESCRIPTION
    The NuGet/PSGallery delivery shape. Given a built bundle (Build-Catzc), it stages a packable module under
    <DestinationPath>/Catzc/<version>/ — the bundle payload plus a generated Catzc.psm1 (RootModule) and
    Catzc.psd1 (the module manifest, the "PSGallery manifest") — and compresses it into
    <DestinationPath>/Catzc.<version>.nupkg with Compress-PSResource (pack only, no publish). Metadata (author,
    company, description, tags, optional project/license URIs) and the stable module GUID come from exporter.yml.
    FunctionsToExport is the enumerated public inventory of the bundled modules — the locked manifest surface.

    Publishing is deliberately not done here: the artifact is produced, and the release workflow (or a manual
    Publish-PSResource) pushes it — to a GitHub Release / GitHub Packages via the GitHub token, or to PSGallery
    with a PSGallery API key. See docs/adr/pipelines/github-release.md.
.PARAMETER Source
    The built bundle root (Build-Catzc output path).
.PARAMETER Version
    The package version (the published semver, exporter.yml version).
.PARAMETER DestinationPath
    The directory to stage the module and write the .nupkg into.
#>
function New-CatzcNuGetPackage {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory)]
        [string] $Source,

        [Parameter(Mandatory)]
        [string] $Version,

        [Parameter(Mandatory)]
        [string] $DestinationPath
    )

    Assert-PathExist $Source -PathType Container
    $config = Get-Config -Config exporter
    $package = $config.package

    # Stage the packable module: the bundle payload + a RootModule + the manifest.
    $moduleDir = Join-Path $DestinationPath "Catzc/$Version"
    if ([System.IO.Directory]::Exists($moduleDir)) {
        [System.IO.Directory]::Delete($moduleDir, $true)
    }
    Copy-Directory -Path $Source -Destination $moduleDir
    Write-CatzcRootModule -Path $moduleDir -Version $Version | Out-Null

    # The locked export inventory: every module's public function names (root *.ps1, not tests, not private).
    $inventory = [System.Collections.Generic.List[string]]::new()
    foreach ($md in [System.IO.Directory]::EnumerateDirectories((Join-Path $moduleDir 'automation'))) {
        if ([System.IO.Path]::GetFileName($md).StartsWith('.')) {
            continue
        }
        foreach ($file in [System.IO.Directory]::EnumerateFiles($md, '*.ps1')) {
            $name = [System.IO.Path]::GetFileNameWithoutExtension($file)
            if (-not $name.EndsWith('.Tests', [System.StringComparison]::OrdinalIgnoreCase)) {
                $inventory.Add($name)
            }
        }
    }
    $exports = [string[]] @($inventory | Sort-Object -Unique)

    $manifestArgs = @{
        Path              = Join-Path $moduleDir 'Catzc.psd1'
        RootModule        = 'Catzc.psm1'
        ModuleVersion     = $Version
        Guid              = "$($config.module_guid)"
        Author            = "$($package.author)"
        CompanyName       = "$($package.company)"
        Description       = "$($package.description)"
        PowerShellVersion = '7.4'
        FunctionsToExport = $exports
        CmdletsToExport   = @()
        VariablesToExport = @()
        AliasesToExport   = @()
        Tags              = [string[]] @($package.tags)
    }
    # The Gallery links come from config; fall back to sensible dummies when blank, so the manifest is always
    # complete rather than silently missing a field.
    $projectUri = "$($package.project_uri)"
    if ([string]::IsNullOrWhiteSpace($projectUri)) {
        $projectUri = 'https://github.com/catzc/catzc'
    }
    $licenseUri = "$($package.license_uri)"
    if ([string]::IsNullOrWhiteSpace($licenseUri)) {
        $licenseUri = "$projectUri/blob/main/LICENSE"
    }
    $manifestArgs.ProjectUri = $projectUri
    $manifestArgs.LicenseUri = $licenseUri
    New-ModuleManifest @manifestArgs

    # Pack (no publish). Compress-PSResource emits <Name>.<Version>.nupkg into DestinationPath.
    Compress-PSResource -Path $moduleDir -DestinationPath $DestinationPath
    $packageFile = Join-Path $DestinationPath "Catzc.$Version.nupkg"

    [pscustomobject]@{
        ModulePath    = $moduleDir
        Manifest      = Join-Path $moduleDir 'Catzc.psd1'
        NuPkg         = $packageFile
        Version       = $Version
        FunctionCount = $exports.Count
    }
}
