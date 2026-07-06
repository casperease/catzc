# Catzc.Internal.Importer — the importer overlay.
#
# The whole load sequence lives here, in Invoke-Importer, whose parameter block is the importer's public
# switch surface. The root importer.ps1 is a thin, GENERATED shim (New-Importer) that carries the same param
# block and delegates here — one living copy of the load logic (see docs/adr/principles/one-living-version.md).
# Like the transient bootstrap, this module is import-time orchestration, not shared library code: the shim
# removes it after Invoke-Importer returns.

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
.PARAMETER NonSilentClear
    Surface the post-import type-cache janitor's report (off by default).
.PARAMETER SkipJanitors
    Skip the post-import janitors and the PSModulePath check — a lean load for a copied subset.
.PARAMETER NoCommitShaMarkersInDevBox
    Opt OUT of the default sha-marker sync + auto-commit. By default every dev-box import syncs the
    marker files and auto-commits the importer-maintained generated files (.sha-markers/,
    automation/.compiled/) via Sync-GeneratedFile — never in a pipeline (double-guarded: the call site
    skips under Test-IsRunningInPipeline and the function self-skips again), and skipped on main/master
    when the git_workspace variant is 'main-via-pr' (ADR-VARIANT:6). Also ignored under -SkipJanitors.
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

        # Show the post-import type-cache janitor's report. Off by default (Clear-ModuleTypeCache is run -Silent so
        # a normal load stays quiet); pass this to see what it cleaned or that it was already clean.
        [switch] $NonSilentClear,

        # Skip the post-import janitors (Clear-ModuleTypeCache, Build-Readme, Build-TerminologyDictionary,
        # Build-RootConfig) and the PSModulePath check — a lean/optimized load for a copied subset
        # (Test-InIsolation). Type loading still fast-paths on the committed .compiled DLL; only the tail
        # maintenance is skipped.
        [switch] $SkipJanitors,

        # Opt OUT of the default sha-marker sync + auto-commit of the generated files the importer
        # maintains (.sha-markers/, automation/.compiled/) — the janitor tail's last step
        # (Sync-GeneratedFile, which self-guards: never a pipeline, main allowed only in the main-direct
        # git_workspace variant).
        [switch] $NoCommitShaMarkersInDevBox
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

    # Repository root — set on $env by the shim (importer.ps1 sets $env:RepositoryRoot = $PSScriptRoot). Read it
    # here; the rest of the toolset also anchors on $env:RepositoryRoot.
    $repoRoot = $env:RepositoryRoot
    Write-Verbose "RepositoryRoot: $repoRoot"

    # The .internal shared-code loader is already imported by the shim (it provides Import-InternalModule).
    # Load the rest of the shared modules on demand. Bootstrap does the import-time discovery/loading and is
    # removed at the end; the loader, Types and Vendor stay in the session (NOT removed), so post-import Catzc
    # cover functions can Import-InternalModule the same shared code and delegate to it. -Force honors the
    # re-import invalidation boundary (cache ADR), so a devbox re-import picks up edits to a shared module.
    Import-InternalModule Bootstrap -Force
    Import-InternalModule Types -Force
    Import-InternalModule Vendor -Force
    if ($DiagnoseLoadTime) {
        Write-LoadTime 'Bootstrap and internal shared modules loaded'
    }

    # Custom error view — shows ScriptStackTrace for unhandled errors
    Update-FormatData -PrependPath (Join-Path $repoRoot "$automationFolder/.internal/assets/ErrorView.format.ps1xml")

    # Load vendored dependencies first
    $vendorRoot = Join-Path $repoRoot "$automationFolder/$vendorFolder"
    Write-Verbose "Loading vendor modules from: $vendorRoot"
    Import-VendorModules -VendorRoot $vendorRoot -Lazy 'Pester', 'PSScriptAnalyzer' -DiagnoseLoadTime:$DiagnoseLoadTime
    if ($DiagnoseLoadTime) {
        Write-LoadTime 'Vendor modules loaded'
    }

    # Discover and import all modules
    $modulesRoot = Join-Path $repoRoot $automationFolder

    # Optionally wipe compiled type DLLs first so the import below rebuilds them from source.
    if ($ClearCompiledTypes) {
        Clear-CompiledType -ModulesRoot $modulesRoot
    }

    Write-Verbose "Discovering modules in: $modulesRoot"
    Import-AllModules -ModulesRoot $modulesRoot -ExportPrivates:$ExportPrivates -DiagnoseLoadTime:$DiagnoseLoadTime
    if ($DiagnoseLoadTime) {
        Write-LoadTime 'All modules loaded'
    }

    if ($DiagnoseLoadTime) {
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

    # Tidy superseded compiled type assemblies so the committed automation/.compiled stays a clean -1/+1 diff when
    # a C# type changes. No-op in CI (Clear-ModuleTypeCache self-skips). Guarded: absent in the bootstrap sandbox.
    # -Silent by default so a normal load is quiet; -NonSilentClear surfaces the janitor's end-state report.
    if (-not $SkipJanitors -and (Get-Command Clear-ModuleTypeCache -ErrorAction Ignore)) {
        Clear-ModuleTypeCache -Silent:(-not $NonSilentClear)
    }

    # Keep the generated README copy-ins current (Catzc.Base.Docs). Fast no-op when nothing changed — Build-Readme
    # rewrites a README only when its composed content differs (compared EOL-insensitively), so a clean tree costs
    # only a few small file reads. Guarded: absent in the bootstrap sandbox, like Clear-ModuleTypeCache.
    if (-not $SkipJanitors -and (Get-Command Build-Readme -ErrorAction Ignore)) {
        Build-Readme -Silent | Out-Null
    }

    # Keep the managed .gitkeep files current (Catzc.Base.Docs). Every .gitkeep is a committed copy of the
    # one generic source, pointing at its folder's generated README — reproduced here so a source change
    # propagates, and a fast no-op on a clean tree. See docs/adr/repository/generated-readmes.md.
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
    # Guarded: absent in the bootstrap sandbox. See docs/adr/repository/generated-root-configs.md.
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

    # Default-on for dev boxes (opt out: -NoCommitShaMarkersInDevBox): sync the sha-marker files and
    # auto-commit the generated files the importer maintains (.sha-markers/, automation/.compiled/).
    # Deliberately the LAST janitor, so tracked files the janitors above touch (the .compiled DLL swap)
    # are in their final state before the durable SHAs are computed. NEVER in a pipeline — guarded here so
    # CI imports stay silent, and again inside Sync-GeneratedFile (which also guards: main only in the
    # main-direct git_workspace variant). Guarded: absent in the bootstrap sandbox.
    if (-not $NoCommitShaMarkersInDevBox -and -not $SkipJanitors -and
        (Get-Command Sync-GeneratedFile -ErrorAction Ignore) -and
        (Get-Command Test-IsRunningInPipeline -ErrorAction Ignore) -and
        -not (Test-IsRunningInPipeline)) {
        Sync-GeneratedFile | Out-Null
    }

    # Warn if PSModulePath contains a network share. The permanent fix is a one-time
    # script that writes a local PSModulePath to the user-scope powershell.config.json.
    # See: automation/Catzc.Base.Environment/assets/README.md
    if (-not $SkipJanitors -and $IsWindows) {
        $hasUncModulePath = ($env:PSModulePath -split [IO.Path]::PathSeparator) -match '^\\\\' | Select-Object -First 1

        if ($hasUncModulePath) {
            $fixScript = Join-Path $repoRoot "$automationFolder/Catzc.Base.Environment/assets/Set-LocalPSModulePath.ps1"
            Write-Host ''
            Write-ImporterMessage 'WARNING: PSModulePath contains a network share.' -ForegroundColor Yellow
            Write-ImporterMessage 'PowerShell will be slow — module lookups scan the network.' -ForegroundColor Yellow
            Write-ImporterMessage 'Run this once to fix:' -ForegroundColor Yellow
            Write-ImporterMessage "  & '$fixScript'" -ForegroundColor Cyan
            Write-Host ''
        }
    }

    # Clean up the bootstrap module — it has served its purpose. Kept loaded until here so the importer output
    # above can route through Write-ImporterMessage (which Catzc.Internal.Bootstrap provides). The other .internal
    # modules (loader, Types, Vendor) stay loaded; only the bootstrap is removed, so its import-time functions do
    # not linger in the session.
    Write-Verbose 'Removing Catzc.Internal.Bootstrap module'
    Remove-Module Catzc.Internal.Bootstrap -Force -ErrorAction SilentlyContinue

    # Console session: load timer.
    # In scripts, authors add `trap { Write-Exception $_; break }` after the importer.
    if ($isConsoleSession) {
        if (Get-Command Write-Message -ErrorAction Ignore) {
            Write-Message "Loaded in $([math]::Round($sw.Elapsed.TotalSeconds, 1)) seconds"
        }
    }
}

Export-ModuleMember -Function Invoke-Importer
