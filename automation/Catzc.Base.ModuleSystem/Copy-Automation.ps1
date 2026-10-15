<#
---
catzc:
  derived:
    path: automation/Catzc.Base.ModuleSystem/Copy-Automation.ps1
    kind: function
    module: Catzc.Base.ModuleSystem
    visibility: public
    adrs:
      - ADR-AUTO-PATH
      - ADR-AUTO-TYPES#9
      - ADR-CONF-LOADING
      - ADR-DSGN-RUNMODE
---
#>

<#
.SYNOPSIS
    Copies a deterministic subset of this repository's automation toolset into a destination, rooted like the
    repository root — for testing in a tmp folder, or vendoring the toolset as a package.
.DESCRIPTION
    Never clobbers: an existing file at the destination aborts the copy before any write, unless -Force.
    [ADR-AUTO-PATH](/docs/adr/automation/path-representation.md),
    [ADR-AUTO-TYPES#9](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types9),
    [ADR-CONF-LOADING](/docs/adr/configuration/module-config-loading.md),
    [ADR-DSGN-RUNMODE](/docs/adr/design/run-modes.md)
    [comment:1](/docs/references/automation/catzc-base-modulesystem/Copy-Automation.ps1.md#comment1)
.PARAMETER Destination
    The target root the selected paths are mirrored into (created if missing).
.PARAMETER ModuleNames
    Disk module names to copy (named + hidden). Default: all ((Get-BaseModule).Name).
.PARAMETER ModuleProfile
    Alternative to -ModuleNames: the profile is widened to its dependency closure plus infrastructure first.
    [comment:2](/docs/references/automation/catzc-base-modulesystem/Copy-Automation.ps1.md#comment2)
.PARAMETER ExcludePackages
    Package names to drop (keys under any module's packages in files.yml). Default: none.
.PARAMETER EmptyDestination
    Require the destination to be empty; throw if it contains anything. Skips the per-file conflict scan.
.PARAMETER Force
    Skip the conflict pre-scan and overwrite existing files.
.PARAMETER DryRun
    Report what would be copied (and any conflicts) without writing anything.
.OUTPUTS
    [string[]] The repository-root-relative source paths copied.
.EXAMPLE
    Copy-Automation -Destination $tmp -ModuleNames Catzc.Base.Config -EmptyDestination
.EXAMPLE
    Copy-Automation -Destination ./vendor/catzc -ExcludePackages gitignore -DryRun
#>
function Copy-Automation {
    [CmdletBinding(DefaultParameterSetName = 'Modules')]
    [OutputType([string[]])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Destination,

        [Parameter(ParameterSetName = 'Modules')]
        [ArgumentCompleter({ (Get-BaseModule).Name })]
        [ValidateScript({ $_ -in (Get-BaseModule).Name })]
        [string[]] $ModuleNames,

        [Parameter(Mandatory, ParameterSetName = 'ModuleProfile')]
        [ArgumentCompleter({ (Get-Config -Config profiles).profiles.Keys })]
        [ValidateScript({ $_ -in (Get-Config -Config profiles).profiles.Keys })]
        [string] $ModuleProfile,

        [ArgumentCompleter({ (Get-BaseModule).Packages.Name })]
        [ValidateScript({ $_ -in (Get-BaseModule).Packages.Name })]
        [string[]] $ExcludePackages = @(),

        [switch] $EmptyDestination,

        [switch] $Force,

        [switch] $DryRun
    )

    Assert-SourceTree

    $emitVerbose = $VerbosePreference -ne [System.Management.Automation.ActionPreference]::SilentlyContinue

    # Which disk modules to copy: a profile's resolved closure, an explicit -ModuleNames, or all (default).
    $selected = if ($PSCmdlet.ParameterSetName -eq 'ModuleProfile') {
        Get-ModuleProfile -Name $ModuleProfile
    }
    elseif ($ModuleNames) {
        $ModuleNames
    }
    else {
        (Get-BaseModule).Name
    }

    # Repository-root-relative sources: each selected module's folder + its packages' paths (minus excluded).
    $relatives = [System.Collections.Generic.List[string]]::new()
    foreach ($module in (Get-BaseModule | Where-Object { $_.Name -in $selected })) {
        $relatives.Add($module.RelativePath)
        foreach ($package in $module.Packages) {
            if ($package.Name -in $ExcludePackages) {
                continue
            }
            foreach ($path in $package.Paths) {
                $relatives.Add([string] $path)
            }
        }
    }

    # Resolve to absolute; drop the sources absent from this tree (e.g. .compiled before a first build).
    $destinationRoot = [System.IO.Path]::GetFullPath($Destination)
    $plan = [System.Collections.Generic.List[object]]::new()
    foreach ($relative in $relatives) {
        $source = Resolve-RepoPath $relative
        if (-not (Test-Path $source)) {
            Write-Message "skipped (absent): $relative" -Verbose:$emitVerbose
            continue
        }
        $plan.Add([pscustomobject]@{
                Relative    = $relative
                Source      = $source
                IsContainer = (Test-Path $source -PathType Container)
                Target      = Join-Path $destinationRoot ($relative -replace '/', [System.IO.Path]::DirectorySeparatorChar)
            })
    }

    # ---- conflict pre-scan (fast / faster / fastest) --------------------------------------------------
    if (-not $Force) {
        if ($EmptyDestination) {
            if ((Test-Path $destinationRoot) -and @(Get-ChildItem -LiteralPath $destinationRoot -Force).Count -gt 0) {
                throw "Copy-Automation: -EmptyDestination requires an empty target, but '$destinationRoot' is not empty."
            }
        }
        else {
            $conflicts = [System.Collections.Generic.List[string]]::new()
            foreach ($item in $plan) {
                if ($item.IsContainer) {
                    foreach ($file in [System.IO.Directory]::EnumerateFiles($item.Source, '*', [System.IO.SearchOption]::AllDirectories)) {
                        $candidate = $item.Target + $file.Substring($item.Source.Length)
                        if (Test-Path -LiteralPath $candidate -PathType Leaf) {
                            $conflicts.Add($candidate)
                        }
                    }
                }
                elseif (Test-Path -LiteralPath $item.Target -PathType Leaf) {
                    $conflicts.Add($item.Target)
                }
            }
            if ($conflicts.Count -gt 0) {
                $shown = ($conflicts | Select-Object -First 20) -join "`n"
                throw ("Copy-Automation: $($conflicts.Count) file(s) already exist at the destination — pass " +
                    "-Force to overwrite, or -EmptyDestination for a clean copy:`n$shown")
            }
        }
    }

    # ---- copy -----------------------------------------------------------------------------------------
    $copied = [System.Collections.Generic.List[string]]::new()
    foreach ($item in $plan) {
        if (-not $DryRun) {
            if ($item.IsContainer) {
                Copy-Directory $item.Source $item.Target
            }
            else {
                [void][System.IO.Directory]::CreateDirectory([System.IO.Path]::GetDirectoryName($item.Target))
                [System.IO.File]::Copy($item.Source, $item.Target, $true)
            }
        }
        $copied.Add($item.Relative)
        Write-Message "$(if ($DryRun) { 'would copy' } else { 'copied' }): $($item.Relative)" -Verbose:$emitVerbose
    }

    $verb = if ($DryRun) {
        'Would copy'
    }
    else {
        'Copied'
    }
    Write-Message "$verb $($copied.Count) source(s) to $destinationRoot"

    [string[]] @($copied)
}
