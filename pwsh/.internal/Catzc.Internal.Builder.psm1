<#
---
catzc:
  docs: "../../docs/references/pwsh/internal/Catzc.Internal.Builder.psm1.md"
  header: "generated"
---
#>

Set-StrictMode -Version Latest

$script:testToolVendorModules = @('Pester', 'PSScriptAnalyzer')

$script:runtimeInternalFiles = @(
    'Catzc.Internal.Bootstrap.psm1'
    'Catzc.Internal.Importer.psm1'
    'Catzc.Internal.Loader.psm1'
    'Catzc.Internal.Types.psm1'
    'Catzc.Internal.Vendor.psm1'
    'assets/ErrorView.format.ps1xml'
    'assets/types-load.yml'
    'assets/types/Build-CombinedTypeAssembly.ps1'
    'assets/types/Get-CombinedTypeHash.ps1'
    'assets/types/Get-LoadedTypeDrift.ps1'
    'assets/types/Get-TypeSourceBody.ps1'
    'assets/types/Get-TypesAssemblyManifest.ps1'
    'assets/types/Write-TypesAssemblyManifest.ps1'
)

$script:fullPolicyInternalFiles = @(
    'Catzc.Internal.TestKit.psm1'
    'assets/PSScriptAnalyzerSettings.psd1'
)

$script:mergedFileSuffix = '.functions.ps1'

# The build functions that outgrew this file live one per file beside it; they share its scope.
. (Join-Path $PSScriptRoot 'assets/builder/Get-BuildClosureViolation.ps1')
. (Join-Path $PSScriptRoot 'assets/builder/Get-MergedModule.ps1')
. (Join-Path $PSScriptRoot 'assets/builder/Get-ModuleBuildPlan.ps1')
. (Join-Path $PSScriptRoot 'assets/builder/Format-CatzcPackageManifest.ps1')
. (Join-Path $PSScriptRoot 'assets/builder/Write-ModuleBuildOutput.ps1')
. (Join-Path $PSScriptRoot 'assets/builder/Clear-StaleBuildFile.ps1')

function Get-BuildSourceIndex {
    [CmdletBinding()]
    [OutputType([System.Collections.Generic.Dictionary[string, bool]])]
    param(
        [Parameter(Mandatory)]
        [string] $SourceRoot
    )

    $listing = Invoke-Executable 'git -c core.quotepath=off ls-files --eol' -WorkingDirectory $SourceRoot -PassThru -Silent -NoAssert
    if ($listing.ExitCode -ne 0) {
        throw "Invoke-ModuleBuild: a bundle is built from the files git tracks, but git cannot list them under '$SourceRoot' ($($listing.Errors))."
    }
    $index = [System.Collections.Generic.Dictionary[string, bool]]::new([System.StringComparer]::Ordinal)
    foreach ($line in ([string] $listing.Output).Split("`n")) {
        $tab = $line.IndexOf("`t")
        if ($tab -lt 0) {
            continue
        }
        $index[$line.Substring($tab + 1).TrimEnd("`r")] = $line.StartsWith('i/lf ', [System.StringComparison]::Ordinal)
    }
    $untracked = Invoke-Executable 'git -c core.quotepath=off ls-files --others --exclude-standard' -WorkingDirectory $SourceRoot -PassThru -Silent
    foreach ($line in ([string] $untracked.Output).Split("`n")) {
        $path = $line.TrimEnd("`r")
        if ($path) {
            $index[$path] = $false   # no stored form to restore: a byte copy
        }
    }
    , $index
}

function Test-BuildSourceDirty {
    [CmdletBinding()]
    [OutputType([bool])]
    param(
        [Parameter(Mandatory)]
        [string] $SourceRoot
    )

    $changed = Invoke-Executable 'git --no-optional-locks diff --quiet HEAD -- .' -WorkingDirectory $SourceRoot -PassThru -Silent -NoAssert
    if ($changed.ExitCode -ne 0) {
        return $true
    }
    $untracked = Invoke-Executable 'git --no-optional-locks ls-files --others --exclude-standard -- .' -WorkingDirectory $SourceRoot -PassThru -Silent
    -not [string]::IsNullOrWhiteSpace([string] $untracked.Output)
}

function Test-BuildSourceLfOnly {
    [CmdletBinding()]
    [OutputType([bool])]
    param(
        [Parameter(Mandatory)]
        [System.Collections.Generic.Dictionary[string, bool]] $Index,

        [Parameter(Mandatory)]
        [string] $SourceRoot,

        [Parameter(Mandatory)]
        [string] $Path
    )

    $isLfOnly = $false
    [void] $Index.TryGetValue([System.IO.Path]::GetRelativePath($SourceRoot, $Path).Replace('\', '/'), [ref] $isLfOnly)
    $isLfOnly
}

function Test-BuildSourceShippable {
    [CmdletBinding()]
    [OutputType([bool])]
    param(
        [Parameter(Mandatory)]
        [System.Collections.Generic.Dictionary[string, bool]] $Index,

        [Parameter(Mandatory)]
        [string] $SourceRoot,

        [Parameter(Mandatory)]
        [string] $Path
    )

    $Index.ContainsKey([System.IO.Path]::GetRelativePath($SourceRoot, $Path).Replace('\', '/'))
}

function Resolve-BuildModuleSet {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [string[]] $Module,

        [string] $ModuleProfile
    )

    $selected = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::Ordinal)
    if ($ModuleProfile) {
        foreach ($name in @(Get-ModuleProfile -Name $ModuleProfile -NoInfrastructure)) {
            [void] $selected.Add($name)
        }
    }
    # An empty -Modules seed resolves to every module, so it is only passed when names were given.
    $named = @($Module | Where-Object { $_ })
    if ($named.Count -gt 0) {
        foreach ($name in @(Get-ModuleProfile -Modules $named -NoInfrastructure)) {
            [void] $selected.Add($name)
        }
    }

    $result = [string[]] @($selected)
    [System.Array]::Sort($result, [System.StringComparer]::Ordinal)
    $result
}

function Get-BuildFileCopy {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory)]
        [string] $SourceDirectory,

        [Parameter(Mandatory)]
        [string] $TargetPath,

        [Parameter(Mandatory)]
        [string] $SourceRoot,

        [Parameter(Mandatory)]
        [System.Collections.Generic.Dictionary[string, bool]] $Index,

        [string[]] $ExcludeDirectory = @(),

        [switch] $IncludeUntracked
    )

    if (-not [System.IO.Directory]::Exists($SourceDirectory)) {
        return
    }
    $sourceFull = [System.IO.Path]::GetFullPath($SourceDirectory)
    foreach ($file in Get-ChildPath $sourceFull -File -Depth 64 -Exclude @() -PruneVendor $false) {
        $relativePath = [System.IO.Path]::GetRelativePath($sourceFull, $file).Replace('\', '/')
        $segments = $relativePath.Split('/')
        $excluded = $false
        for ($position = 0; $position -lt $segments.Count - 1; $position++) {
            if ($segments[$position] -in $ExcludeDirectory) {
                $excluded = $true
                break
            }
        }
        if (-not $excluded -and ($IncludeUntracked -or (Test-BuildSourceShippable -Index $Index -SourceRoot $SourceRoot -Path $file))) {
            $normalize = Test-BuildSourceLfOnly -Index $Index -SourceRoot $SourceRoot -Path $file
            [pscustomobject]@{ Path = "$TargetPath/$relativePath"; Kind = 'Copy'; Source = $file; Content = $null; Exports = $null; Normalize = $normalize }
        }
    }
}

function Copy-BuildFileIfChanged {
    [CmdletBinding()]
    [OutputType([bool])]
    param(
        [Parameter(Mandatory)]
        [string] $Source,

        [Parameter(Mandatory)]
        [string] $Destination,

        [switch] $Normalize
    )

    [byte[]] $bytes = [System.IO.File]::ReadAllBytes($Source)
    if ($Normalize -and [System.Array]::IndexOf($bytes, [byte] 13) -ge 0) {
        $bytes = [System.Text.Encoding]::Latin1.GetBytes([System.Text.Encoding]::Latin1.GetString($bytes).Replace("`r`n", "`n"))
    }
    if ([System.IO.File]::Exists($Destination)) {
        if ([System.Linq.Enumerable]::SequenceEqual($bytes, [byte[]] [System.IO.File]::ReadAllBytes($Destination))) {
            return $false
        }
        [System.IO.File]::Delete($Destination)
    }
    [System.IO.Directory]::CreateDirectory([System.IO.Path]::GetDirectoryName($Destination)) | Out-Null
    [System.IO.File]::WriteAllBytes($Destination, $bytes)
    $true
}

function Get-BuildSourceCommit {
    [CmdletBinding()]
    [OutputType([string])]
    param()

    try {
        Get-GitCurrentCommit
    }
    catch {
        Write-Verbose "No source commit recorded: $($_.Exception.Message)"
        $null
    }
}

function Invoke-ModuleBuild {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [string[]] $Module,

        [string] $ModuleProfile,

        [Parameter(Mandatory)]
        [string] $Version,

        [Parameter(Mandatory)]
        [ValidateSet('runtime', 'full')]
        [string] $VendorPolicy,

        [Parameter(Mandatory)]
        [string] $Destination,

        [Parameter(Mandatory)]
        [string] $Bundle,

        [Parameter(Mandatory)]
        [hashtable] $PackageMetadata,

        [switch] $DryRun
    )

    Assert-SourceTree -Command 'Invoke-ModuleBuild'
    if (-not $ModuleProfile -and @($Module | Where-Object { $_ }).Count -eq 0) {
        throw 'Invoke-ModuleBuild: name the modules to build with -Module, -ModuleProfile, or both.'
    }
    if ($Version -notmatch '^\d+\.\d+\.\d+$') {
        throw "Invoke-ModuleBuild: -Version '$Version' is not MAJOR.MINOR.PATCH; resolve 'auto' before calling the engine (Resolve-CatzcBuildVersion)."
    }
    $guid = [guid]::Empty
    if (-not [guid]::TryParse([string] $PackageMetadata['Guid'], [ref] $guid)) {
        throw "Invoke-ModuleBuild: -PackageMetadata Guid '$($PackageMetadata['Guid'])' is not a GUID."
    }
    foreach ($key in 'Author', 'Description') {
        if ([string]::IsNullOrWhiteSpace([string] $PackageMetadata[$key])) {
            throw "Invoke-ModuleBuild: -PackageMetadata $key is required for Catzc.psd1."
        }
    }

    $sourceRoot = [System.IO.Path]::GetFullPath((Join-Path (Get-RepositoryRoot) (Get-CatzcModulesFolder)))
    $buildRoot = [System.IO.Path]::GetFullPath([System.IO.Path]::Combine($Destination, 'Catzc', $Version))
    $modules = [string[]] @(Resolve-BuildModuleSet -Module $Module -ModuleProfile $ModuleProfile)

    $index = Get-BuildSourceIndex -SourceRoot $sourceRoot
    $dirty = Test-BuildSourceDirty -SourceRoot $sourceRoot
    if ($dirty -and (Test-IsRunningInPipeline)) {
        throw 'Invoke-ModuleBuild: the source tree differs from its commit (git status lists changes under the modules folder). A pipeline builds only a clean commit, so the bundle is that commit''s bytes.'
    }

    Import-InternalModule Types
    $parsedScripts = [Catzc.Base.Repository.ParsedScripts]::new()
    $plan = Get-ModuleBuildPlan -SourceRoot $sourceRoot -Module $modules -Version $Version -VendorPolicy $VendorPolicy -PackageMetadata $PackageMetadata -Index $index -ParsedScripts $parsedScripts
    if ($plan.Violations.Count -gt 0) {
        throw ("Invoke-ModuleBuild: $($plan.Violations.Count) problem(s) in the source tree prevent the build (merge preconditions, ADR-PWSH-MANIFEST-BUNDLECARRIESMANIFESTS):`n  " +
            ($plan.Violations -join "`n  "))
    }

    # The closure check: the code itself, not only dependencies.yml, must be satisfied by the selection.
    $outside = @(Get-BuildClosureViolation -SourceRoot $sourceRoot -Module $modules -Index $index -ParsedScripts $parsedScripts)
    if ($outside.Count -gt 0) {
        throw ("Invoke-ModuleBuild: $($outside.Count) call(s) or config read(s) of the selected modules land outside the build (ADR-AUTO-BUNDLE-IMMUTABLEBUILD). " +
            "Declare the dependency in dependencies.yml so the closure brings the owner in, or add the owning module to the build:`n  " + ($outside -join "`n  "))
    }

    $plannedPaths = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
    foreach ($entry in $plan.Entries) {
        [void] $plannedPaths.Add($entry.Path)
    }
    $missing = [System.Collections.Generic.List[string]]::new()
    $dependencies = @(if ($modules.Count -gt 0) {
            Get-InternalAssetDependency -ModulesRoot $sourceRoot -Module $modules -ParsedScripts $parsedScripts
        })
    foreach ($dependency in $dependencies) {
        $childPath = ([string] $dependency.ChildPath).Replace('\', '/').TrimEnd('/')
        while ($childPath.StartsWith('./')) {
            $childPath = $childPath.Substring(2)
        }
        $target = if ($childPath) {
            "$($dependency.Module)/$childPath"
        }
        else {
            [string] $dependency.Module
        }
        $prefix = "$target/"
        $present = $plannedPaths.Contains($target)
        foreach ($plannedPath in $plannedPaths) {
            if ($present) {
                break
            }
            $present = $plannedPath.StartsWith($prefix, [System.StringComparison]::OrdinalIgnoreCase)
        }
        if (-not $present) {
            $missing.Add("$target (read by $($dependency.Function), $($dependency.File):$($dependency.Line))")
        }
    }
    if ($missing.Count -gt 0) {
        throw ("Invoke-ModuleBuild: $($missing.Count) internal asset dependency path(s) would be missing from the build (ADR-AUTO-ASSETDEP-ENFORCEDMECHANICALLY). " +
            "Ship the asset in the module's configs/ or assets/, or add the owning module to the build:`n  " + ($missing -join "`n  "))
    }

    $fileCount = $plan.Entries.Count + 1
    if ($DryRun) {
        return [pscustomobject]@{
            BuildRoot   = $buildRoot
            Version     = $Version
            Modules     = $modules
            TypesHash   = $plan.TypesHash
            ContentHash = $null
            FileCount   = $fileCount
            Dirty       = $dirty
            DryRun      = $true
        }
    }

    $built = Write-ModuleBuildOutput -SourceRoot $sourceRoot -BuildRoot $buildRoot -Entries $plan.Entries
    if ($null -ne $built -and $built.Hash -ne $plan.TypesHash) {
        throw "Invoke-ModuleBuild: C# type sources changed during the build ($($plan.TypesHash) -> $($built.Hash)). Rebuild."
    }

    $contentHash = Get-CatzcContentHash -Path $buildRoot -Exclude 'build.json'
    $record = [ordered]@{
        name         = 'Catzc'
        bundle       = $Bundle
        version      = $Version
        contentHash  = $contentHash
        typesHash    = $plan.TypesHash
        typeSources  = [string[]] @($plan.TypeSources)
        sourceCommit = Get-BuildSourceCommit
        dirty        = $dirty
        vendorPolicy = $VendorPolicy
        modules      = $modules
    }
    [void] (Write-FileIfChanged -Path ([System.IO.Path]::Combine($buildRoot, 'build.json')) -Content ($record | ConvertTo-Json -Depth 5))

    [pscustomobject]@{
        BuildRoot   = $buildRoot
        Version     = $Version
        Modules     = $modules
        TypesHash   = $plan.TypesHash
        ContentHash = $contentHash
        FileCount   = $fileCount
        Dirty       = $dirty
        DryRun      = $false
    }
}

Export-ModuleMember -Function Invoke-ModuleBuild
