# Catzc.Internal.Importer — the importer overlay.
#
# The whole load sequence lives here, in Invoke-Importer, whose parameter block is the importer's public
# switch surface. The root importer.ps1 is a thin, GENERATED shim (New-Importer) that carries the same param
# block and delegates here — one living copy of the load logic (see
# [ADR-PRIN-ONELIVE](/docs/adr/principles/one-living-version.md)).
# Like the transient bootstrap, this module is import-time orchestration, not shared library code: the shim
# removes it after Invoke-Importer returns.

Set-StrictMode -Version Latest   # this module's scope: every function here runs strict

<#
.SYNOPSIS
    Runs the toolset's whole load sequence — the single living copy of the importer body.
.DESCRIPTION
    Called by the generated importer.ps1 shim, which carries the same public switch block and sets
    $env:RepositoryRoot first. Loads the .internal shared modules, the vendored dependencies, and every
    automation module, then runs the post-import janitors and removes the transient bootstrap. Its parameter
    block is asserted to match importer.ps1 (New-Importer generates the shim from it).
.PARAMETER ExportPrivates
    Export private (private/) functions too, so tests can reach them.
.PARAMETER AllowWarnings
    Set $global:WarningPreference to Continue instead of Stop (warnings do not fail the load).
.PARAMETER DiagnoseLoadTime
    Emit per-stage load timings and an end-of-load summary.
.PARAMETER ClearCompiledTypes
    Delete every compiled C# type DLL before importing so types rebuild from source.
.PARAMETER SkipJanitors
    Skip the post-import janitors and the PSModulePath check — a lean load for a copied subset.
.PARAMETER CleanClone
    Opt IN to a whitelisted deep clean as the janitor run's first step: Reset-GitCleanFxd deletes only
    the auto-controlled generated artifacts a `git clean -fxd` would remove (managed root configs,
    module manifests, generated READMEs, cspell dictionaries, out/, IDE bin/obj) and keeps — reported — any
    untracked file that is not the automation's to delete. The regenerating janitors that follow
    rematerialise what it removed, so one -CleanClone import leaves a pristine, fully-generated clone
    (the module manifests reappear on the next import, exactly as on a fresh clone). Ignored under
    -SkipJanitors.
.PARAMETER Bundle
    Load as an installed bundle rather than the mono repo: honour the pre-set $env:CatzcModulesRoot (the
    bundle's own automation/, set by its Catzc.psm1) instead of deriving it from RepositoryRoot, and force
    -SkipJanitors. Only the bundle bootstrap passes it; the mono shim never does.
.EXAMPLE
    Invoke-Importer -DiagnoseLoadTime
#>
function Invoke-Importer {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingWriteHost', '', Justification = 'Importer console output runs before the module system (Write-Message) is available')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidGlobalVars', '', Justification = 'Session-global by design: $global:__CatzcLoadTimings is the cross-module load-timing collector created here under -DiagnoseLoadTime, appended to by the Bootstrap loaders across module imports, and summarized at the end — it must be global to survive across those imports (Bootstrap.psm1 carries the same suppression)')]
    [CmdletBinding()]
    param(
        [switch] $ExportPrivates,
        [switch] $AllowWarnings,
        [switch] $DiagnoseLoadTime,

        # Delete every compiled C# type DLL before importing, so each type is rebuilt from source rather than
        # loaded from its committed/cached assembly. Use it to build from source (e.g. verify a clean rebuild).
        [switch] $ClearCompiledTypes,

        # Skip the post-import janitors (Clear-ModuleTypeCache, Build-Readme, Build-TerminologyDictionary,
        # Build-RootConfig) and the PSModulePath check — a lean/optimized load for a copied subset
        # (Test-InIsolation). Type loading still fast-paths on the committed .compiled DLL; only the tail
        # maintenance is skipped.
        [switch] $SkipJanitors,

        # Opt IN to a whitelisted deep clean as the janitor run's first step (Reset-GitCleanFxd): delete
        # only the auto-controlled generated artifacts, keep and report everything else, and let the
        # regenerating janitors below rematerialise the tree.
        [switch] $CleanClone,

        # Load as an installed bundle, not the mono repo. Honour the pre-set $env:CatzcModulesRoot (the bundle's
        # own automation/, set by its Catzc.psm1) instead of deriving it from RepositoryRoot, and force
        # -SkipJanitors (a bundle is a read-only install with no git work tree). Only the bundle bootstrap passes
        # this; the mono shim never does, so an inherited CatzcModulesRoot can never divert a mono/fixture load.
        [switch] $Bundle
    )

    # Hard floor: the toolset requires PowerShell 7.4+. Among other things the vendor functions
    # (Catzc.Base.Vendor) use the bundled Microsoft.PowerShell.PSResourceGet, first shipped in 7.4.
    if ($PSVersionTable.PSVersion -lt [version]'7.4') {
        throw "The Catzc toolset requires PowerShell 7.4 or later (found $($PSVersionTable.PSVersion))."
    }

    # Strict mode
    Set-StrictMode -Version Latest

    # Detect a direct console session vs a load from within a script. The overlay runs one call below the
    # generated importer.ps1 shim, so the stack is [0] Invoke-Importer, [1] importer.ps1, [2] the shim's caller.
    # An empty ScriptName at [2] means importer.ps1 was dot-sourced with no calling script (a console session).
    # This reproduces the shim's own `-not $MyInvocation.ScriptName` from inside the module.
    $stack = Get-PSCallStack
    $callerScriptName = if ($stack.Count -gt 2) {
        $stack[2].ScriptName
    }
    else {
        $null
    }
    $isConsoleSession = [string]::IsNullOrEmpty($callerScriptName)

    if ($isConsoleSession) {
        $sw = [Diagnostics.Stopwatch]::StartNew()
    }
    # Times only the module import (vendor + automation modules), so the console load line can split it from
    # the session initializer/finalizer around it (session setup and internal modules before, janitors after).
    $importSw = [Diagnostics.Stopwatch]::new()

    if ($DiagnoseLoadTime) {
        $script:diagSw = [Diagnostics.Stopwatch]::StartNew()
        function script:Write-LoadTime {
            param([string] $Step)
            Write-ImporterMessage ('{0,6}ms  {1}' -f [int]$script:diagSw.Elapsed.TotalMilliseconds, $Step) -ForegroundColor DarkGray
            $script:diagSw.Restart()
        }
        # Collectors the Bootstrap loaders (incl. Import-CSharpTypes) append to, summarized at the end.
        $global:__CatzcLoadTimings = [System.Collections.Generic.List[object]]::new()
    }

    # -Verbose shows the importer's own state-change record
    # ([ADR-AUTO-ANNOUNCE#6](/docs/adr/automation/powershell/announce-state-changes.md#rule-adr-auto-announce6)). The
    # dot-sourced shim binds it in
    # the caller's scope, so for the import the session-wide preference is quieted, restored in the finally below:
    # otherwise every Import-Module the load runs would list each function it dot-sources and exports.
    $showStateChanges = $VerbosePreference -ne 'SilentlyContinue'
    $callerVerbosePreference = $global:VerbosePreference
    $global:VerbosePreference = 'SilentlyContinue'
    try {
        # Configuration
        $automationFolder = 'automation'
        $vendorFolder = '.vendor'

        # Global error handling — fail fast on errors and warnings by default
        $global:ErrorActionPreference = 'Stop'
        $global:WarningPreference = if ($AllowWarnings) {
            'Continue'
        }
        else {
            'Stop'
        }
        $global:InformationPreference = 'Continue'

        # A redirected session writes UTF-8, the encoding the process relays stream, so a captured log is one
        # encoding; announced with the preferences below.
        $outputEncodingChanged = Set-RedirectedOutputEncoding

        # Repository root — the WORKING root (out/, repo-relative paths, git), set on $env by the shim
        # (importer.ps1 sets $env:RepositoryRoot = $PSScriptRoot). Read it here; working-root readers anchor on it.
        $repoRoot = $env:RepositoryRoot
        Write-Verbose "RepositoryRoot: $repoRoot"

        # Catzc code anchor — the automation/ tree that holds the loaded modules; config, type and vendor discovery
        # follow THIS, not RepositoryRoot (see Get-CatzcModulesRoot). In the mono repo it equals <repoRoot>/automation
        # and nothing pre-sets it, so it is derived here (a no-op split). An installed bundle's Catzc.psm1 pre-sets it
        # to the bundle's own automation/, so the importer honours that — this is what makes catzc relocatable.
        if ($Bundle -and $env:CatzcModulesRoot) {
            $modulesRoot = $env:CatzcModulesRoot
        }
        else {
            $modulesRoot = Join-Path $repoRoot $automationFolder
        }
        $env:CatzcModulesRoot = $modulesRoot
        Write-Verbose "CatzcModulesRoot: $modulesRoot"

        # A bundle is a read-only install with no git work tree: never run the tree/git-mutating janitors.
        if ($Bundle) {
            $SkipJanitors = $true
        }

        # The .internal shared-code loader is already imported by the shim (it provides Import-InternalModule).
        # Load the rest of the shared modules on demand. Bootstrap does the import-time discovery/loading and is
        # removed at the end; the loader, Types and Vendor stay in the session (NOT removed), so post-import Catzc
        # cover functions can Import-InternalModule the same shared code and delegate to it. -Force honors the
        # re-import invalidation boundary (cache ADR), so a devbox re-import picks up edits to a shared module.
        Import-InternalModule Bootstrap -Force
        Import-InternalModule Types -Force
        Import-InternalModule Vendor -Force
        # Hand the setting to the bootstrap writer, which the vendor and bootstrap module functions announce through.
        Set-ImporterVerbosity -Enabled $showStateChanges
        if ($DiagnoseLoadTime) {
            Write-LoadTime 'Bootstrap and internal shared modules loaded'
        }

        # Custom error view — shows ScriptStackTrace for unhandled errors
        $errorViewPath = Join-Path $modulesRoot '.internal/assets/ErrorView.format.ps1xml'
        Update-FormatData -PrependPath $errorViewPath

        # Every lasting change to the caller's session is announced
        # ([ADR-AUTO-ANNOUNCE#2](/docs/adr/automation/powershell/announce-state-changes.md#rule-adr-auto-announce2)):
        # the preferences and the
        # error view, then the two roots and the internal modules that stay loaded — RepositoryRoot set by the
        # importer.ps1 shim and the modules by Import-InternalModule, which both delegate their announcement here.
        # This is the first point Write-ImporterMessage (Catzc.Internal.Bootstrap) is loaded. Like every announcement
        # of the importer's own load, they go on its verbose record
        # ([ADR-AUTO-ANNOUNCE#6](/docs/adr/automation/powershell/announce-state-changes.md#rule-adr-auto-announce6)).
        Write-ImporterMessage ("Session: ErrorActionPreference=$global:ErrorActionPreference, WarningPreference=$global:WarningPreference, " +
            "InformationPreference=$global:InformationPreference, error view '$errorViewPath'") -StateChange
        if ($outputEncodingChanged) {
            Write-ImporterMessage 'Session: console output encoding UTF-8 (output is redirected)' -StateChange
        }
        Write-ImporterMessage ("Roots: RepositoryRoot='$repoRoot', CatzcModulesRoot='$modulesRoot'; " +
            'internal modules Catzc.Internal.Loader, Catzc.Internal.Types, Catzc.Internal.Vendor') -StateChange

        # Load vendored dependencies first
        $importSw.Start()
        $vendorRoot = Join-Path $modulesRoot $vendorFolder
        Write-Verbose "Loading vendor modules from: $vendorRoot"
        Import-VendorModules -VendorRoot $vendorRoot -Lazy 'Pester', 'PSScriptAnalyzer' -DiagnoseLoadTime:$DiagnoseLoadTime
        $importSw.Stop()
        if ($DiagnoseLoadTime) {
            Write-LoadTime 'Vendor modules loaded'
        }

        # Discover and import all modules from the catzc code anchor computed above ($modulesRoot).
        # Optionally wipe compiled type DLLs first so the import below rebuilds them from source.
        if ($ClearCompiledTypes) {
            Clear-CompiledType -ModulesRoot $modulesRoot
        }

        $importSw.Start()

        Write-Verbose "Discovering modules in: $modulesRoot"
        Import-AllModules -ModulesRoot $modulesRoot -ExportPrivates:$ExportPrivates -DiagnoseLoadTime:$DiagnoseLoadTime -Bundle:$Bundle
        $importSw.Stop()

        # The two run modes never coexist ([ADR-DSGN-RUNMODE#5](/docs/adr/design/run-modes.md#rule-adr-dsgn-runmode5)):
        # Import-AllModules evicted the other mode, and this
        # proves it before any janitor touches the tree from a mixed session.
        Assert-CatzcRunModeExclusive -ModulesRoot $modulesRoot
        if ($DiagnoseLoadTime) {
            Write-LoadTime 'All modules loaded'
        }

        if ($DiagnoseLoadTime) {
            Write-LoadTimeSummary
        }

        # Opt-in deep clean (-CleanClone): the whitelisted git clean -fxd (Reset-GitCleanFxd) deletes only the
        # auto-controlled generated artifacts and keeps — reported — any untracked file that is not the
        # automation's to delete. Deliberately the FIRST janitor, so the regenerating janitors below
        # rematerialise what it removed in the same run. Guarded: absent in the bootstrap sandbox.
        if ($CleanClone -and -not $SkipJanitors -and (Get-Command Reset-GitCleanFxd -ErrorAction Ignore)) {
            Reset-GitCleanFxd
        }

        # Tidy superseded type assemblies (.compiled stays a clean -1/+1 diff) — see Invoke-TypeCacheJanitor.
        if (-not $SkipJanitors) {
            Invoke-TypeCacheJanitor -ShowReport:$showStateChanges
        }

        # Keep the generated ADR pages current (Catzc.Base.Docs): [index](/docs/adr/index.md) from adrs.yml and
        # [glossary](/docs/adr/glossary.md) from the glossary sources — committed so GitHub has them, rebuilt BEFORE
        # Build-Readme (the docs/adr README is generated from the index). See [ADR-REPO-README](/docs/adr/repository/generated-readmes.md).
        if (-not $SkipJanitors -and (Get-Command Build-AdrIndex -ErrorAction Ignore)) {
            Build-AdrIndex -Silent | Out-Null
            Build-Glossary -Silent | Out-Null
        }

        # Keep the generated README copy-ins current (Catzc.Base.Docs). Fast no-op when nothing changed — Build-Readme
        # rewrites a README only when its composed content differs (compared EOL-insensitively), so a clean tree costs
        # only a few small file reads. Guarded: absent in the bootstrap sandbox, like Clear-ModuleTypeCache.
        if (-not $SkipJanitors -and (Get-Command Build-Readme -ErrorAction Ignore)) {
            Build-Readme -Silent | Out-Null
        }

        # Keep the managed .gitkeep files current (Catzc.Base.Docs). Every .gitkeep is a committed copy of the
        # one generic source, pointing at its folder's generated README — reproduced here so a source change
        # propagates, and a fast no-op on a clean tree. See [ADR-REPO-README](/docs/adr/repository/generated-readmes.md).
        if (-not $SkipJanitors -and (Get-Command Build-GitKeep -ErrorAction Ignore)) {
            Build-GitKeep -Silent | Out-Null
        }

        # Keep the generated cspell dictionaries current (Catzc.Base.QualityGates). They are derived from
        # configs/terminology.yml — gitignored, not committed — so the registry is the single source of truth and
        # cspell still resolves them at fixed paths. Fast no-op when nothing changed (writes only on drift).
        if (-not $SkipJanitors -and (Get-Command Build-TerminologyDictionary -ErrorAction Ignore)) {
            Build-TerminologyDictionary -Silent | Out-Null
        }

        # Keep the managed root config files current (Catzc.Base.RootConfig). Every opted-in root file is
        # reproduced from its single in-repo source of truth — an authored source copied out with a generated-file
        # header (e.g. the root PSScriptAnalyzerSettings.psd1 from .internal/assets), or a generator's rendered
        # output (e.g. New-Importer for importer.ps1). Rewrites only on drift, so a clean tree is a fast no-op.
        # Guarded: absent in the bootstrap sandbox. See [ADR-REPO-ROOTCFG](/docs/adr/repository/generated-root-configs.md).
        if (-not $SkipJanitors -and (Get-Command Build-RootConfig -ErrorAction Ignore)) {
            Build-RootConfig -Silent | Out-Null
        }

        # Reconcile the session PATH to whatever tools are actually present — including tools installed outside the
        # installer layer (e.g. nvm-managed node) — and report any running from a non-owned location on one line.
        # Session-only, quiet on a clean devbox, self-skips in CI. The importer is dot-sourced, so its PATH nudges
        # land in the caller's live session. Guarded: absent in the bootstrap sandbox (Catzc.Tooling.Core).
        if (-not $SkipJanitors -and (Get-Command Sync-SessionTools -ErrorAction Ignore)) {
            Sync-SessionTools
        }

        # Commit the generated files the importer maintains (automation/.compiled/) — who is running decides
        # ([ADR-AUTO-TYPES#13](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types13)): a person's session
        # commits, an agent's announces what changed and leaves the commit to the person, a test-run snapshot never
        # commits, and a pipeline is not even asked, so CI imports stay silent. Deliberately the LAST janitor, so
        # tracked files the janitors above touch (the .compiled DLL swap) are in their final state.
        # Guarded: absent in the bootstrap sandbox.
        if (-not $SkipJanitors -and (Get-Command Sync-GeneratedFile -ErrorAction Ignore) -and
            (Get-SessionActor) -ne 'Pipeline') {
            Sync-GeneratedFile | Out-Null
        }

        # Warn if PSModulePath contains a network share. The permanent fix is a one-time
        # script that writes a local PSModulePath to the user-scope powershell.config.json.
        # See: automation/Catzc.Base.Environment/assets/README.md
        if (-not $SkipJanitors -and $IsWindows) {
            $hasUncModulePath = ($env:PSModulePath -split [IO.Path]::PathSeparator) -match '^\\\\' | Select-Object -First 1

            if ($hasUncModulePath) {
                $fixScript = Join-Path $modulesRoot 'Catzc.Base.Environment/assets/Set-LocalPSModulePath.ps1'
                Write-ImporterMessage ''
                Write-ImporterMessage 'WARNING: PSModulePath contains a network share.' -ForegroundColor Yellow
                Write-ImporterMessage 'PowerShell will be slow — module lookups scan the network.' -ForegroundColor Yellow
                Write-ImporterMessage 'Run this once to fix:' -ForegroundColor Yellow
                Write-ImporterMessage "  & '$fixScript'" -ForegroundColor Cyan
                Write-ImporterMessage ''
            }
        }

        # Clean up the bootstrap module — it has served its purpose. Kept loaded until here so the importer output
        # above can route through Write-ImporterMessage (which Catzc.Internal.Bootstrap provides). The other .internal
        # modules (loader, Types, Vendor) stay loaded; only the bootstrap is removed, so its import-time functions do
        # not linger in the session.
        Write-Verbose 'Removing Catzc.Internal.Bootstrap module'
        Remove-Module Catzc.Internal.Bootstrap -Force -ErrorAction SilentlyContinue -Verbose:$false

        # Console session: load timer, split into the module import and the session initializer/finalizer around it.
        # In scripts, authors add `trap { Write-Exception $_; break }` after the importer.
        if ($isConsoleSession) {
            if (Get-Command Write-Message -ErrorAction Ignore) {
                $totalSeconds = [math]::Round($sw.Elapsed.TotalSeconds, 1)
                $importSeconds = [math]::Round($importSw.Elapsed.TotalSeconds, 1)
                $frameSeconds = [math]::Round($sw.Elapsed.TotalSeconds - $importSw.Elapsed.TotalSeconds, 1)
                Write-Message "Loaded in $totalSeconds seconds (module import ${importSeconds}s, session initializer/finalizer ${frameSeconds}s)"
            }
        }
    }
    finally {
        $global:VerbosePreference = $callerVerbosePreference
    }
}

<#
.SYNOPSIS
    Throws unless every loaded catzc module comes from the active code root.
.DESCRIPTION
    Run at the importer tail in both run modes
    ([ADR-DSGN-RUNMODE#5](/docs/adr/design/run-modes.md#rule-adr-dsgn-runmode5)). Every loaded module named 'Catzc' or
    'Catzc.*' — the Catzc.Internal.* loader modules included, vendored third-party modules excluded by name —
    must have its ModuleBase under the active CatzcModulesRoot (Get-ForeignCatzcModule, the same predicate the
    eviction sweep uses). A violation names every offending module with its ModuleBase, the active root, and
    the other root(s) the offenders came from. Internal to the importer overlay: it needs the transient
    bootstrap, which is still loaded at this point.
.PARAMETER ModulesRoot
    The active code root.
#>
function Assert-CatzcRunModeExclusive {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string] $ModulesRoot
    )

    $offenders = @(Get-ForeignCatzcModule -ModulesRoot $ModulesRoot -IncludeInternal)
    if ($offenders.Count -eq 0) {
        return
    }

    $otherRoots = [System.Collections.Generic.List[string]]::new()
    $lines = foreach ($module in $offenders) {
        $otherRoot = [System.IO.Path]::GetDirectoryName($module.ModuleBase)
        if (-not $otherRoots.Contains($otherRoot)) {
            $otherRoots.Add($otherRoot)
        }
        "  $($module.Name) ($($module.ModuleBase))"
    }
    $header = "Run-mode exclusivity violated: the active CatzcModulesRoot is '$ModulesRoot', but $($offenders.Count) loaded catzc module(s) come from another root ('$($otherRoots -join "', '")'):"
    $footer = 'Restart PowerShell, or re-run the entry script of the mode you want.'
    throw ((@($header) + @($lines) + @($footer)) -join "`n")
}

function Set-RedirectedOutputEncoding {
    <#
    .SYNOPSIS
        Makes a redirected session write UTF-8, so a captured log has one encoding.
    .DESCRIPTION
        When the session's standard output goes to a file or a pipe, the host encodes everything it writes with
        [Console]::OutputEncoding — the OEM codepage on Windows — while the process relays (CliRunner, PesterRunner)
        stream UTF-8, so one captured log mixed two encodings and the box drawing came out mangled. An interactive
        console writes Unicode directly and is left as it is. Returns $true when it changed the encoding, so the
        caller announces it on the importer's load record
        ([ADR-AUTO-ANNOUNCE#1](/docs/adr/automation/powershell/announce-state-changes.md#rule-adr-auto-announce1)
        names this as the one console property the toolset assigns).
    #>
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('Measure-NoRawConsoleWrite', '', Justification = 'The one sanctioned console-property assignment (ADR-AUTO-ANNOUNCE#1): UTF-8 output for a redirected session, announced by Invoke-Importer on its load record.')]
    [CmdletBinding()]
    [OutputType([bool])]
    param()

    if (-not [Console]::IsOutputRedirected -or [Console]::OutputEncoding.CodePage -eq 65001) {
        return $false
    }
    [Console]::OutputEncoding = [System.Text.UTF8Encoding]::new($false)
    $true
}

<#
.SYNOPSIS
    Writes the -DiagnoseLoadTime summary: file-read and parse totals, and the three slowest load stages.
.DESCRIPTION
    Reads the $global:__CatzcLoadTimings collector Invoke-Importer creates under -DiagnoseLoadTime and the Bootstrap
    loaders append to. Internal to the importer overlay: it writes through the transient bootstrap's
    Write-ImporterMessage, which is still loaded at this point.
#>
function Invoke-TypeCacheJanitor {
    <#
    .SYNOPSIS
        Runs the post-import type-cache janitor (Clear-ModuleTypeCache) without ever failing the load.
    .DESCRIPTION
        -Silent unless -ShowReport (the importer passes its -Verbose); CI self-skips inside Clear-ModuleTypeCache. A
        superseded build it cannot delete (held outside catzc) becomes one red line, never a failed load. Holders are
        stopped in a person's session only — never an agent's, never CI's (Get-SessionActor,
        [ADR-AUTO-TYPES#13](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types13)). A no-op when
        Clear-ModuleTypeCache is absent (the bootstrap sandbox).
    .PARAMETER ShowReport
        Show the janitor's end-state report.
    #>
    [CmdletBinding()]
    param(
        [switch] $ShowReport
    )

    if (-not (Get-Command Clear-ModuleTypeCache -ErrorAction Ignore)) {
        return
    }
    try {
        Clear-ModuleTypeCache -Silent:(-not $ShowReport) -StopLockingProcesses:((Get-SessionActor) -eq 'Person')
    }
    catch {
        Write-ImporterMessage $_.Exception.Message -ForegroundColor Red
    }
}

function Write-LoadTimeSummary {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidGlobalVars', '', Justification = 'Reads $global:__CatzcLoadTimings, the cross-module load-timing collector Invoke-Importer creates under -DiagnoseLoadTime')]
    [CmdletBinding()]
    param()

    Write-ImporterMessage '  ---- summary ----' -ForegroundColor DarkGray

    # raw-read is a pure [IO.File]::ReadAllText of every .ps1 BEFORE Import-Module, so it isolates the cold
    # file-READ I/O (disk / network share / antivirus-on-read) from the parse. It is warm-cached after the
    # first access — small here does NOT mean "no AV": an AV that scans on script *parse* (AMSI) is not a
    # read, so that cost lands in parse/compile below, not here. Don't read this as "antivirus time".
    $scanMs = [int](($global:__CatzcLoadTimings | Measure-Object ReadMs -Sum).Sum)
    $scanFiles = [int](($global:__CatzcLoadTimings | Measure-Object FileCount -Sum).Sum)
    $parseMs = [int](($global:__CatzcLoadTimings | Measure-Object ImportMs -Sum).Sum)
    Write-ImporterMessage ('  file-read I/O (cold; warm-cached after 1st access): {0}ms across {1} .ps1 files' -f $scanMs, $scanFiles) -ForegroundColor DarkGray
    Write-ImporterMessage ('  Import-Module parse/compile (incl. any AV/AMSI scan-on-parse): {0}ms' -f $parseMs) -ForegroundColor DarkGray
    # The native C# type compile/load (every module's types/*.cs via Import-CSharpTypes) appears as one
    # 'types (combined)' row below; a 'compile+load' row is a cold cache (Roslyn), a 'cache load' row reused
    # the committed automation/.compiled DLL.
    $top = $global:__CatzcLoadTimings | Sort-Object Ms -Descending | Select-Object -First 3
    foreach ($t in $top) {
        Write-ImporterMessage ('  slowest: {0,6}ms  {1}' -f $t.Ms, $t.Stage) -ForegroundColor DarkGray
    }
}

Export-ModuleMember -Function Invoke-Importer
