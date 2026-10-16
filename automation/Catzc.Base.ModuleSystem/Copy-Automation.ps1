<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.ModuleSystem/Copy-Automation.ps1
    name: copy-automation
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.ModuleSystem
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    page: docs/references/automation/catzc-base-modulesystem/Copy-Automation.ps1.md
    test: automation/Catzc.Base.ModuleSystem/tests/Copy-Automation.Tests.ps1
    cites:
      - ADR-AUTO-PATH
      - ADR-AUTO-TYPES#9
      - ADR-CONF-LOADING
      - ADR-DSGN-RUNMODE
      - ADR-PWSH-ENUM#{1,3}
  config:
    synopsis: |-
      Copies a deterministic subset of this repository's automation toolset into a destination, rooted like the
      repository root — for testing in a tmp folder, or vendoring the toolset as a package.
    description: |-
      The source is always this repository (Get-RepositoryRoot). What to copy is chosen off the module
      resolver (Get-CatzcModule) and the profile closure (Get-ModuleProfile):

        -ModuleNames      which modules to copy (the code track's modules and its infrastructure folders). Default: all
                          (the `full` profile).
        -ExcludePackages  a global list of package names to drop. A package is a named group of extra file
                          artifacts a module owns (configs/files.yml) — e.g. the repository module's
                          'root_configs' and 'gitignore', or the types module's 'csproj'. Default: none.

      Each selected module copies its folder plus each of its packages whose name is not excluded, to the SAME
      repository-root-relative path under -Destination, so the destination becomes a new root mirroring ours. A
      source that is selected but absent from this tree (e.g. .compiled before a first build) is skipped.

      Conflict handling is a fast pre-scan (fast / faster / fastest):
        - default          full pre-scan; if any file it would write already exists, throw and list them —
                           nothing is written (never clobbers).
        - -EmptyDestination require the target to be empty (or absent); throw otherwise. The pristine-copy
                           contract used by Pester against a fresh tmp directory.
        - -Force           skip the pre-scan and overwrite.

      The copy is of the source tree (per-function files, tests/, root packages), so it stops with a named error
      in build mode (Assert-SourceTree, [ADR-DSGN-RUNMODE](/docs/adr/design/run-modes.md)).

      See [ADR-CONF-LOADING](/docs/adr/configuration/module-config-loading.md) (files.yml),
      [ADR-AUTO-TYPES#9](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types9), and
      [ADR-AUTO-PATH](/docs/adr/automation/path-representation.md).
    parameters:
      Destination: The target root the selected paths are mirrored into (created if missing).
      ModuleNames: 'Module names to copy (modules + infrastructure folders). Default: all (Get-ModuleProfile -Name full).'
      ModuleProfile: |-
        A named module profile from configs/profiles.yml (minimal, azure, …), resolved to its dependency closure +
        infrastructure via Get-ModuleProfile. Alternative to -ModuleNames.
      ExcludePackages: 'Package names to drop (keys under any module''s packages in files.yml). Default: none.'
      EmptyDestination: Require the destination to be empty; throw if it contains anything. Skips the per-file conflict scan.
      Force: Skip the conflict pre-scan and overwrite existing files.
      DryRun: Report what would be copied (and any conflicts) without writing anything.
    outputs: '[string[]] The repository-root-relative source paths copied.'
    examples:
      - Copy-Automation -Destination $tmp -ModuleNames Catzc.Base.Config -EmptyDestination
      - Copy-Automation -Destination ./vendor/catzc -ExcludePackages gitignore -DryRun
---
#>

function Copy-Automation {
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

    $codePlace = @(Get-Track).Where({ $_.type -ceq 'modules' })[0].places[0]
    $moduleRoots = @{}
    foreach ($module in Get-CatzcModule -TrackType modules) {
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
                Target      = Join-Path $destinationRoot ($relative -replace '/', [System.IO.Path]::DirectorySeparatorChar)
            })
    }

    # ---- conflict pre-scan (fast / faster / fastest) --------------------------------------------------
    if (-not $Force) {
        if ($EmptyDestination) {
            if ([System.IO.Directory]::Exists($destinationRoot) -and [System.IO.Directory]::EnumerateFileSystemEntries($destinationRoot).GetEnumerator().MoveNext()) {
                throw "Copy-Automation: -EmptyDestination requires an empty target, but '$destinationRoot' is not empty."
            }
        }
        else {
            $conflicts = [System.Collections.Generic.List[string]]::new()
            foreach ($item in $plan) {
                if ($item.IsContainer) {
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
