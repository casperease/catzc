<#
.SYNOPSIS
    Builds the immutable, installable Catzc bundle into out/ — the build-once artifact.
.DESCRIPTION
    Assembles a self-contained copy of the catzc platform under out/catzc/<version>/: the selected profile's
    runtime payload (Copy-CatzcLiveTree — tracked module files minus tests, .internal, the vendored deps per
    policy, and the prebuilt combined-types DLL), plus a generated bundle importer.ps1 and a build.json
    provenance record carrying the content-addressed hash. The tree mirrors the repository layout, so the same
    path-resolution seams work unchanged when it is loaded from anywhere (RepositoryRoot = the bundle,
    CatzcModulesRoot = the bundle's automation/). Runs in the mono repo (git + the committed DLL available);
    writes only under out/ (never mutates the automation tree), so it is safe and isolated from mono usage.

    Defaults come from configs/exporter.yml (Get-Config -Config exporter); explicit params override.
.PARAMETER ModuleProfile
    The module set to bundle — a profiles.yml key (default: exporter.yml default_profile; full = everything).
.PARAMETER VendorPolicy
    runtime (default: exporter.yml vendor_policy) carries only powershell-yaml; full also carries Pester/PSSA.
.PARAMETER Version
    The bundle version / folder name (default: Get-CatzcVersion — the 6.6.666 direct-install sentinel).
.PARAMETER Silent
    Suppress the one-line build summary.
.EXAMPLE
    Build-Catzc
.EXAMPLE
    Build-Catzc -ModuleProfile full -VendorPolicy full
#>
function Build-Catzc {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [string] $ModuleProfile,
        [ValidateSet('runtime', 'full')]
        [string] $VendorPolicy,
        [string] $Version,
        [switch] $Silent
    )

    $config = Get-Config -Config exporter
    if (-not $ModuleProfile) {
        $ModuleProfile = "$($config.default_profile)"
    }
    if (-not $VendorPolicy) {
        $VendorPolicy = "$($config.vendor_policy)"
    }
    if (-not $Version) {
        $Version = Get-CatzcVersion
    }

    $bundleRoot = Join-Path (Get-OutputRoot -EnsureExists) "catzc/$Version"
    if ([System.IO.Directory]::Exists($bundleRoot)) {
        [System.IO.Directory]::Delete($bundleRoot, $true)
    }

    $modules = Get-ModuleProfile -Name $ModuleProfile -NoInfrastructure
    $payload = Copy-CatzcLiveTree -Destination $bundleRoot -Module $modules -VendorPolicy $VendorPolicy
    Write-CatzcBundleBootstrap -Root $bundleRoot -Version $Version | Out-Null

    # Content-addressed identity over the payload; build.json (written below) is excluded — it carries the hash.
    $contentHash = Get-CatzcContentHash -Path $bundleRoot -Exclude 'build.json'

    $sourceCommit = try {
        Get-GitCurrentCommit
    }
    catch {
        'unknown'
    }

    $build = [ordered]@{
        name         = 'Catzc'
        version      = $Version
        contentHash  = $contentHash
        profile      = $ModuleProfile
        vendorPolicy = $VendorPolicy
        sourceCommit = $sourceCommit
        builtUtc     = [datetime]::UtcNow.ToString('o')
        moduleCount  = $modules.Count
        fileCount    = $payload.Count
        modules      = $modules
    }
    $buildJson = ($build | ConvertTo-Json -Depth 5)
    [System.IO.File]::WriteAllText((Join-Path $bundleRoot 'build.json'), $buildJson + "`n", [System.Text.UTF8Encoding]::new($false))

    # Verify what we just built (reproducibility, aspect purity, prebuilt DLL, importer present).
    Assert-CatzcBundle -Path $bundleRoot

    if (-not $Silent) {
        Write-Message "Built Catzc $Version bundle ($($modules.Count) modules, $($payload.Count) files, hash $($contentHash.Substring(0, 12))) -> $(ConvertTo-RepoRelativePath $bundleRoot)"
    }

    [pscustomobject]@{
        Path        = $bundleRoot
        Version     = $Version
        ContentHash = $contentHash
        ModuleCount = $modules.Count
        FileCount   = $payload.Count
    }
}
