# .SYNOPSIS
#     Imports all module directories under a given root path.
# .DESCRIPTION
#     Running importer modules are never touched mid-load; the exclusivity assert reports any that are foreign.
# .PARAMETER ModulesRoot
#     Path to the directory containing module folders.
function Import-AllModules {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidGlobalVars', '',
        Justification = '$global:__CatzcLoadTimings is session-global import diagnostics collected across all modules, surfaced by importer.ps1 -DiagnoseLoadTime')]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$ModulesRoot,

        [switch]$ExportPrivates,

        # Emit a per-module load-time breakdown: manifest generation, a raw-read probe (cold file I/O), and
        # Import-Module (parse). Surfaced by importer.ps1 -DiagnoseLoadTime so an author can see WHICH
        # module(s) are slow and whether the cost is file I/O (raw-read column) or parse (import column);
        # manifest enumeration is native .NET and consistently ~1-7ms. Off = no overhead.
        [switch]$DiagnoseLoadTime,

        # Read-only bundle load: manifests must be pre-generated (never written), and the combined-types DLL
        # must be shipped (never compiled). Passed by Invoke-Importer -Bundle; off for the mono repo.
        [switch]$Bundle,

        # The importer passes console for an interactive dot-source; the types-load policy decides lazy or eager from
        # it.
        [ValidateSet('console', 'headless')]
        [string]$HostKind = 'headless'
    )

    # One level, inline: this module loads before the walker exists
    # ([ADR-PWSH-ENUM-EARLYLOADINGCODE](/docs/drs/automation/pwsh/bounded-enumeration.md#rule-adr-pwsh-enum-earlyloadingcode)).
    $moduleDirs = [System.IO.DirectoryInfo]::new($ModulesRoot).GetDirectories() |
        Where-Object { $_.Name -notmatch '^\.' }

    # Fail fast on duplicate exported function names BEFORE any module or C# type loads — a collision would
    # otherwise be silent (the module imported last shadows the others).
    Assert-UniqueModuleFunctionName -ModuleDirs $moduleDirs -ExportPrivates:$ExportPrivates

    $sw = if ($DiagnoseLoadTime) {
        [Diagnostics.Stopwatch]::StartNew()
    }
    else {
        $null
    }

    # Remove previously loaded catzc modules (handles deleted/renamed modules). Exclude Bootstrap, the
    # vendored third-party modules (.vendor), and the .internal shared modules — the last are loaded by the
    # importer before this runs and must SURVIVE into the session (Import-CSharpTypes and post-import cover
    # functions call them); they live under the modules root, so without this they match the stale sweep.
    $stale = @(Get-Module |
            Where-Object {
                $_.Path -like "$ModulesRoot*" -and $_.Name -ne 'Bootstrap' -and
                $_.Path -notlike '*/.vendor/*' -and $_.Path -notlike '*\.vendor\*' -and
                $_.Path -notlike '*/.internal/*' -and $_.Path -notlike '*\.internal\*'
            })
    foreach ($module in $stale) {
        Write-Verbose "Removing stale module: $($module.Name)"
        Remove-Module $module.Name -Force -ErrorAction SilentlyContinue
    }

    # Evict the other run mode: a catzc module loaded from a different root (a build when loading the source
    # tree, or the reverse) is removed, taking its script scope — and every $script: cache — with it. Removal is
    # by module INSTANCE (-ModuleInfo), never by name: Import-Module -Force of a same-named module from another
    # path loads a second instance beside the first, so the shim's own imports of this root's Loader, Importer,
    # Bootstrap, Types and Vendor leave the other root's instances in the module table, and removing just those
    # keeps this root's commands intact. A Catzc.Internal.* module this root has not loaded yet (an on-demand
    # one, e.g. TestKit) is re-imported from THIS root's .internal by path (Import-InternalModule -Force
    # semantics, anchored here — the loader itself may be the foreign one). The running importer modules are
    # never removed unless this root's instance is the one running. Removal tolerates a module already gone
    # with its parent; Invoke-Importer's exclusivity assert (after the load) proves nothing foreign survived.
    $rootInternal = [System.IO.Path]::GetFullPath([System.IO.Path]::Combine($ModulesRoot, '.internal')).TrimEnd('\',
        '/')
    $evicted = [System.Collections.Generic.List[string]]::new()
    foreach ($foreign in @(Get-ForeignCatzcModule -ModulesRoot $ModulesRoot -IncludeInternal)) {
        $isInternal = $foreign.Name -like 'Catzc.Internal.*'
        $hasLocal = $isInternal -and [bool](Get-Module $foreign.Name | Where-Object {
                $_.ModuleBase -and [System.IO.Path]::GetFullPath($_.ModuleBase).TrimEnd('\', '/') -ieq $rootInternal
            })
        if (-not $hasLocal -and $foreign.Name -in 'Catzc.Internal.Importer', 'Catzc.Internal.Bootstrap') {
            continue
        }
        Write-Verbose "Evicting $($foreign.Name) loaded from another root: $($foreign.ModuleBase)"
        Remove-Module -ModuleInfo $foreign -Force -ErrorAction SilentlyContinue
        $evicted.Add($foreign.Name)
        $internalPath = [System.IO.Path]::Combine($rootInternal, "$($foreign.Name).psm1")
        if ($isInternal -and -not $hasLocal -and [System.IO.File]::Exists($internalPath)) {
            Write-Verbose "Reloading $($foreign.Name) from $rootInternal"
            Import-Module $internalPath -Scope Global -Force
        }
    }
    if ($DiagnoseLoadTime) {
        Write-ImporterMessage ('    {0,6}ms  (remove stale modules)' -f [int]$sw.Elapsed.TotalMilliseconds) -ForegroundColor DarkGray
    }

    # Native C# types (every module's types/*.cs) compile/load ONCE, before any module's functions, into a
    # single combined assembly — so a function (or a module's load-time code) can reference any type, and a
    # type in one module can reference a type in another. Module import order below is therefore irrelevant.
    Import-CSharpTypes -ModulesRoot $ModulesRoot -DiagnoseLoadTime:$DiagnoseLoadTime -PrebuiltOnly:$Bundle -HostKind $HostKind

    $imported = [System.Collections.Generic.List[string]]::new()
    $commandNames = [System.Collections.Generic.List[string]]::new()
    foreach ($dir in $moduleDirs) {
        if ($DiagnoseLoadTime) {
            $sw.Restart()
        }
        $manifestPath = New-DynamicManifest -ModulePath $dir.FullName -ExportPrivates:$ExportPrivates -ReadOnly:$Bundle
        $manifestMs = if ($DiagnoseLoadTime) {
            [int]$sw.Elapsed.TotalMilliseconds
        }
        else {
            0
        }

        if ($manifestPath) {
            Write-Verbose "Importing module: $($dir.Name)"

            # Diagnostic probe: read every .ps1 this module imports, raw, BEFORE Import-Module. This pays
            # the cold per-file *open* cost — the part an antivirus real-time scan or a network share
            # intercepts — so the Import-Module that follows reads from warm OS cache and its time is ≈ pure
            # parse/compile. Splitting them is the point: raw-read = I/O cost, import = parse cost. Only the
            # set Import-Module will load (root + private .ps1, no tests), so the warming is representative.
            $readMs = 0
            $fileCount = 0
            if ($DiagnoseLoadTime) {
                $sw.Restart()
                foreach ($pf in [System.IO.Directory]::EnumerateFiles($dir.FullName, '*.ps1')) {
                    if (-not $pf.EndsWith('.Tests.ps1', [System.StringComparison]::OrdinalIgnoreCase)) {
                        [void][System.IO.File]::ReadAllText($pf)
                        $fileCount++
                    }
                }
                $privateDir = [System.IO.Path]::Combine($dir.FullName,
                    (Get-PrivateFunctionFolder -ModulesRoot $ModulesRoot))
                if ([System.IO.Directory]::Exists($privateDir)) {
                    foreach ($pf in [System.IO.Directory]::GetFiles($privateDir, '*.ps1')) {
                        [void][System.IO.File]::ReadAllText($pf)
                        $fileCount++
                    }
                }
                $readMs = [int]$sw.Elapsed.TotalMilliseconds
            }

            if ($DiagnoseLoadTime) {
                $sw.Restart()
            }
            $importedModule = Import-Module $manifestPath -Scope Global -Force -PassThru | Select-Object -First 1
            # A session-level Set-StrictMode does not reach module code, so strict mode is set in each module's own
            # script scope, which every function in the module inherits
            # ([ADR-PWSH-ERROR](/docs/drs/automation/pwsh/error-handling.md)).
            . $importedModule { Set-StrictMode -Version Latest }
            $imported.Add($importedModule.Name)
            $commandNames.AddRange([string[]]@($importedModule.ExportedCommands.Keys))
            if ($DiagnoseLoadTime) {
                $importMs = [int]$sw.Elapsed.TotalMilliseconds
                $total = $manifestMs + $readMs + $importMs
                Write-ImporterMessage ('    {0,6}ms  {1} (manifest {2}ms + raw-read {3}ms + import {4}ms)' -f $total,
                    $dir.Name, $manifestMs, $readMs, $importMs) -ForegroundColor DarkGray
                if ($null -ne (Get-Variable -Name '__CatzcLoadTimings' -Scope Global -ValueOnly -ErrorAction Ignore)) {
                    $global:__CatzcLoadTimings.Add([pscustomobject]@{ Stage = $dir.Name; Ms = $total; ReadMs = $readMs; ImportMs = $importMs; FileCount = $fileCount })
                }
            }
        }
        else {
            # Clean up stale .psd1 if module dir became empty
            $stalePsd1 = Join-Path $dir.FullName "$(Resolve-ModuleName -Folder $dir.Name -Namespace (Get-ModuleNamespace -ModulesRoot $ModulesRoot)).psd1"
            if ([System.IO.File]::Exists($stalePsd1)) {
                [System.IO.File]::Delete($stalePsd1)
            }
        }
    }

    # Installed last, once every command name is known: the first lookup of one of them loads the types still pending.
    Enable-DeferredTypesLoad -CommandName $commandNames

    # Loading and unloading modules changes the session, so it is announced
    # ([ADR-AUTO-CONSOLE-ANNOUNCELASTINGCHANGES](/docs/drs/automation/console-output-matters.md#rule-adr-auto-console-announcelastingchanges)) on the
    # importer's
    # verbose record
    # ([ADR-PWSH-ANNOUNCE-IMPORTERLOADSEQUENCE](/docs/drs/automation/pwsh/announce-state-changes.md#rule-adr-pwsh-announce-importerloadsequence)): one
    # line names
    # the load, plus any module that left the session for good — evicted from another root, or gone from the tree.
    # A re-import's remove-then-reload of the same modules is not a departure and is not listed.
    $summary = "Loaded $($imported.Count) modules from '$ModulesRoot'"
    if ($evicted.Count) {
        $summary += "; evicted from another root: $($evicted -join ', ')"
    }
    $gone = @(foreach ($module in $stale) {
            if ($module.Name -notin $imported) {
                $module.Name
            }
        })
    if ($gone.Count) {
        $summary += "; removed, no longer in the tree: $($gone -join ', ')"
    }
    Write-ImporterMessage $summary -StateChange
}
