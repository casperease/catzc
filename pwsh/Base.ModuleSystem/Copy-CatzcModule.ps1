function Copy-CatzcModule {
    [CmdletBinding(DefaultParameterSetName = 'Modules')]
    [OutputType([string[]])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Destination,

        [Parameter(ParameterSetName = 'Modules')]
        [ArgumentCompleter({ Get-ModuleProfile -Name full })]
        [ValidateScript({ $_ -in (Get-ModuleProfile -Name full) })]
        [string[]] $ModuleNames,

        [Parameter(Mandatory, ParameterSetName = 'ModuleProfile')]
        [ArgumentCompleter({ (Get-Config -Config profiles).profiles.Keys })]
        [ValidateScript({ $_ -in (Get-Config -Config profiles).profiles.Keys })]
        [string] $ModuleProfile,

        [ArgumentCompleter({ (Get-Config -Config files).modules.Values.packages.Keys })]
        [ValidateScript({ $_ -in (Get-Config -Config files).modules.Values.packages.Keys })]
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
        Get-ModuleProfile -Name full
    }

    # Each selected module's folder, as the resolver roots it, plus its packages' paths; infrastructure folders sit in the first place.
    $codePlace = Get-CatzcModulesFolder
    $moduleRoots = @{}
    foreach ($module in Get-CatzcModule -EngineTrack) {
        $moduleRoots[$module.name] = $module.root
    }
    $bindings = (Get-Config -Config files).modules
    $relatives = [System.Collections.Generic.List[string]]::new()
    foreach ($name in $selected) {
        $relatives.Add($moduleRoots.ContainsKey($name) ? $moduleRoots[$name] : "$codePlace/$name")
        if (-not $bindings.Contains($name)) {
            continue
        }
        $packages = $bindings[$name].packages
        foreach ($packageName in $packages.Keys) {
            if ($packageName -in $ExcludePackages) {
                continue
            }
            foreach ($path in $packages[$packageName]) {
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
                Target      = Join-Path $destinationRoot ($relative -replace '/',
                    [System.IO.Path]::DirectorySeparatorChar)
            })
    }

    # ---- conflict pre-scan (fast / faster / fastest) --------------------------------------------------
    if (-not $Force) {
        if ($EmptyDestination) {
            # A one-level walk with nothing excluded and the vendor folder not pruned, so an entry of any kind, hidden or not, counts.
            if ([System.IO.Directory]::Exists($destinationRoot) -and
                @(Get-ChildPath $destinationRoot -Depth 1 -Exclude @() -PruneVendor $false).Count -gt 0) {
                throw "Copy-CatzcModule: -EmptyDestination requires an empty target, but '$destinationRoot' is not empty."
            }
        }
        else {
            $conflicts = [System.Collections.Generic.List[string]]::new()
            foreach ($item in $plan) {
                if ($item.IsContainer) {
                    # A named whole-tree walk: every file the copy would write is checked for a conflict.
                    foreach ($file in Get-ChildPath $item.Source -File -Depth 64 -Exclude @() -PruneVendor $false) {
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
                throw ("Copy-CatzcModule: $($conflicts.Count) file(s) already exist at the destination — pass " +
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
