# -DryRun, not ShouldProcess or -WhatIf: the branch comes before any side effect.
function Build-Modules {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseSingularNouns', '',
        Justification = 'Builds a set of modules; the plural is the contract name (ADR-AUTO-BUNDLE-ISBUILD)')]
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Position = 0)]
        [string[]] $Module,

        [string] $Bundle = "$((Get-Config -Config exporter).default_bundle)",

        [string] $ModuleProfile = $(
            $bundles = (Get-Config -Config exporter).bundles
            if (-not $Module -and $bundles.ContainsKey($Bundle)) {
                "$($bundles[$Bundle].profile)"
            }
        ),

        [ValidateSet('runtime', 'full')]
        [string] $VendorPolicy = $(
            $bundles = (Get-Config -Config exporter).bundles
            if ($bundles.ContainsKey($Bundle)) {
                "$($bundles[$Bundle].vendor_policy)"
            }
        ),

        [string] $Version = 'auto',

        [string] $Destination = (Join-Path (Get-OutputRoot) "pwsh/built/$Bundle"),

        [switch] $DryRun,

        [switch] $Silent
    )

    $config = Get-Config -Config exporter
    Assert-True ($config.bundles.ContainsKey($Bundle)) -ErrorText "Unknown bundle '$Bundle': exporter.yml declares $(@($config.bundles.Keys) -join ', ')."
    $resolvedVersion = Resolve-CatzcBuildVersion -Version $Version -Bundle $Bundle -Silent:$Silent

    $package = $config.package
    $engineArguments = @{
        Version         = $resolvedVersion
        VendorPolicy    = $VendorPolicy
        Destination     = $Destination
        Bundle          = $Bundle
        PackageMetadata = @{
            Guid        = "$($config.module_guid)"
            Author      = "$($package.author)"
            CompanyName = "$($package.company)"
            Description = "$($package.description)"
            Tags        = [string[]] @($package.tags)
            ProjectUri  = "$($package.project_uri)"
            LicenseUri  = "$($package.license_uri)"
        }
        DryRun          = [bool] $DryRun
    }
    if ($Module) {
        $engineArguments.Module = $Module
    }
    if ($ModuleProfile) {
        $engineArguments.ModuleProfile = $ModuleProfile
    }

    # The engine is an .internal module loaded on demand and invoked by name, which keeps it off the static dependency graph.
    Import-InternalModule Builder
    $engine = 'Invoke-ModuleBuild'
    $result = & $engine @engineArguments

    if (-not $DryRun) {
        # The footprint limits describe the bundle as declared; a build with an overridden selection or vendor policy is not it.
        $isDeclaredBundle = -not ($PSBoundParameters.ContainsKey('Module') -or
            $PSBoundParameters.ContainsKey('ModuleProfile') -or
            $PSBoundParameters.ContainsKey('VendorPolicy'))
        if ($isDeclaredBundle) {
            Assert-BundleFootprint -Path $result.BuildRoot -Bundle $config.bundles[$Bundle] | Out-Null
        }
        Assert-CatzcBundle -Path $result.BuildRoot
    }

    if (-not $Silent) {
        $verb = if ($DryRun) {
            'Would build'
        }
        else {
            'Built'
        }
        Write-Message "$verb Catzc $Bundle $($result.Version) ($(@($result.Modules).Count) modules, $($result.FileCount) files, types $($result.TypesHash)) -> $(ConvertTo-RepoRelativePath $result.BuildRoot)"
    }

    $result
}
