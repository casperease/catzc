# Catzc.Internal.Importer — the importer overlay.
# [ADR-PRIN-ONELIVE](/docs/adr/principles/one-living-version.md)
# [comment:1](/docs/references/automation/internal/Catzc.Internal.Importer.psm1.md#comment1)

Set-StrictMode -Version Latest   # this module's scope: every function here runs strict

<#
.SYNOPSIS
    Runs the toolset's whole load sequence — the single living copy of the importer body.
.DESCRIPTION
    Called by the generated importer.ps1 shim, which carries the same public switch block and sets...
    [comment:2](/docs/references/automation/internal/Catzc.Internal.Importer.psm1.md#comment2)
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
    Opt IN to a whitelisted deep clean as the janitor run's first step: Reset-GitCleanFxd deletes only the...
    [comment:3](/docs/references/automation/internal/Catzc.Internal.Importer.psm1.md#comment3)
.PARAMETER Bundle
    Load as an installed bundle rather than the mono repo: honour the pre-set $env:CatzcModulesRoot (the bundle's own...
    [comment:4](/docs/references/automation/internal/Catzc.Internal.Importer.psm1.md#comment4)
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

        # Delete every compiled C# type DLL before importing, so each type is rebuilt from source rather than loaded...
        # [comment:5](/docs/references/automation/internal/Catzc.Internal.Importer.psm1.md#comment5)
        [switch] $ClearCompiledTypes,

        # Skip the post-import janitors (Clear-ModuleTypeCache, Build-Readme, Build-TerminologyDictionary,...
        # [comment:6](/docs/references/automation/internal/Catzc.Internal.Importer.psm1.md#comment6)
        [switch] $SkipJanitors,

        # Opt IN to a whitelisted deep clean as the janitor run's first step (Reset-GitCleanFxd): delete only the...
        # [comment:7](/docs/references/automation/internal/Catzc.Internal.Importer.psm1.md#comment7)
        [switch] $CleanClone,

        # Load as an installed bundle, not the mono repo.
        # [comment:8](/docs/references/automation/internal/Catzc.Internal.Importer.psm1.md#comment8)
        [switch] $Bundle
    )

    # Hard floor: the toolset requires PowerShell 7.4+.
    # [comment:9](/docs/references/automation/internal/Catzc.Internal.Importer.psm1.md#comment9)
    if ($PSVersionTable.PSVersion -lt [version]'7.4') {
        throw "The Catzc toolset requires PowerShell 7.4 or later (found $($PSVersionTable.PSVersion))."
    }

    # Strict mode
    Set-StrictMode -Version Latest

    # Detect a direct console session vs a load from within a script.
    # [comment:10](/docs/references/automation/internal/Catzc.Internal.Importer.psm1.md#comment10)
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
    # Times only the module import (vendor + automation modules), so the console load line can split it from the...
    # [comment:11](/docs/references/automation/internal/Catzc.Internal.Importer.psm1.md#comment11)
    $importSw = [Diagnostics.Stopwatch]::new()

    if ($DiagnoseLoadTime) {
        $script:diagSw = [Diagnostics.Stopwatch]::StartNew()
        # Collectors the Bootstrap loaders (incl. Import-CSharpTypes) append to, summarized at the end.
        $global:__CatzcLoadTimings = [System.Collections.Generic.List[object]]::new()
    }

    # -Verbose shows the importer's own state-change record.
    # [ADR-PWSH-ANNOUNCE#6](/docs/adr/pwsh/announce-state-changes.md#rule-adr-pwsh-announce6)
    # [comment:12](/docs/references/automation/internal/Catzc.Internal.Importer.psm1.md#comment12)
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

        # A redirected session writes UTF-8, the encoding the process relays stream, so a captured log is one...
        # [comment:13](/docs/references/automation/internal/Catzc.Internal.Importer.psm1.md#comment13)
        $outputEncodingChanged = Set-RedirectedOutputEncoding

        # Repository root — the WORKING root (out/, repo-relative paths, git), set on $env by the shim (importer.ps1...
        # [comment:14](/docs/references/automation/internal/Catzc.Internal.Importer.psm1.md#comment14)
        $repoRoot = $env:RepositoryRoot
        Write-Verbose "RepositoryRoot: $repoRoot"

        # Catzc code anchor — the automation/ tree that holds the loaded modules; config, type and vendor discovery...
        # [comment:15](/docs/references/automation/internal/Catzc.Internal.Importer.psm1.md#comment15)
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

        # The.internal shared-code loader is already imported by the shim (it provides Import-InternalModule).
        # [comment:16](/docs/references/automation/internal/Catzc.Internal.Importer.psm1.md#comment16)
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

        # Every lasting change to the caller's session is announced: the preferences and the error view, then the two...
        # [ADR-AUTO-CONSOLE#11](/docs/adr/automation/console-output-matters.md#rule-adr-auto-console11),
        # [ADR-PWSH-ANNOUNCE#6](/docs/adr/pwsh/announce-state-changes.md#rule-adr-pwsh-announce6)
        # [comment:17](/docs/references/automation/internal/Catzc.Internal.Importer.psm1.md#comment17)
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
        # [comment:18](/docs/references/automation/internal/Catzc.Internal.Importer.psm1.md#comment18)
        if ($ClearCompiledTypes) {
            Clear-CompiledType -ModulesRoot $modulesRoot
        }

        $importSw.Start()

        Write-Verbose "Discovering modules in: $modulesRoot"
        Import-AllModules -ModulesRoot $modulesRoot -ExportPrivates:$ExportPrivates -DiagnoseLoadTime:$DiagnoseLoadTime -Bundle:$Bundle
        $importSw.Stop()

        # The two run modes never coexist: Import-AllModules evicted the other mode, and this proves it before any...
        # [ADR-DSGN-RUNMODE#5](/docs/adr/design/run-modes.md#rule-adr-dsgn-runmode5)
        # [comment:19](/docs/references/automation/internal/Catzc.Internal.Importer.psm1.md#comment19)
        Assert-CatzcRunModeExclusive -ModulesRoot $modulesRoot

        if ($Bundle) {
            Invoke-ConsumerOverlay -RepositoryRoot $repoRoot
        }
        if ($DiagnoseLoadTime) {
            Write-LoadTime 'All modules loaded'
        }

        if ($DiagnoseLoadTime) {
            Write-LoadTimeSummary
        }

        # The post-import janitors, in their fixed order (Invoke-ImporterJanitors).
        # [comment:20](/docs/references/automation/internal/Catzc.Internal.Importer.psm1.md#comment20)
        if (-not $SkipJanitors) {
            Invoke-ImporterJanitors -CleanClone:$CleanClone -ShowStateChanges:$showStateChanges
        }

        # Warn if PSModulePath contains a network share.
        # [comment:21](/docs/references/automation/internal/Catzc.Internal.Importer.psm1.md#comment21)
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

        # Remove the bootstrap, kept until here for Write-ImporterMessage, so its import-time functions do not...
        # [comment:22](/docs/references/automation/internal/Catzc.Internal.Importer.psm1.md#comment22)
        Write-Verbose 'Removing Catzc.Internal.Bootstrap module'
        Remove-Module Catzc.Internal.Bootstrap -Force -ErrorAction SilentlyContinue -Verbose:$false

        # Console session: load timer, split into the module import and the session initializer/finalizer around it.
        # [comment:23](/docs/references/automation/internal/Catzc.Internal.Importer.psm1.md#comment23)
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
    Run at the importer tail in both run modes.
    [ADR-DSGN-RUNMODE#5](/docs/adr/design/run-modes.md#rule-adr-dsgn-runmode5)
    [comment:24](/docs/references/automation/internal/Catzc.Internal.Importer.psm1.md#comment24)
.PARAMETER ModulesRoot
    The active code root.
#>
function Invoke-ConsumerOverlay {
    <#
    .SYNOPSIS
        Applies a consumer's overlay at the end of a bundle load, or stops the load when the bundle cannot.
    .DESCRIPTION
        A consumer changes a built bundle only through the overlay in its working root.
        [ADR-AUTO-OVERLAY](/docs/adr/automation/consumer-overlay.md)
        [comment:25](/docs/references/automation/internal/Catzc.Internal.Importer.psm1.md#comment25)
    .PARAMETER RepositoryRoot
        The working root of the load.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string] $RepositoryRoot
    )

    if (-not [System.IO.Directory]::Exists([System.IO.Path]::Combine($RepositoryRoot, '.catzc', 'automation'))) {
        return
    }
    if (-not (Get-Command Import-CatzcOverlay -ErrorAction Ignore)) {
        throw "The working root '$RepositoryRoot' has a consumer overlay (.catzc/automation/), but this bundle does not carry Catzc.Base.Overlay, which applies it. Use a bundle whose profile includes Catzc.Base.Overlay, or remove the overlay."
    }
    $applied = @(Import-CatzcOverlay)
    $overrides = @($applied | Where-Object { $_.Kind -eq 'FunctionOverride' }).Count
    $locals = @($applied | Where-Object { $_.Kind -eq 'LocalModule' }).Count
    if ($applied.Count -gt 0) {
        Write-ImporterMessage "Overlay: $overrides function override(s) applied, $locals local module(s) loaded from .catzc/automation" -StateChange
    }
}

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
        When the session's standard output goes to a file or a pipe, the host encodes everything it writes with...
        [ADR-PWSH-ANNOUNCE#1](/docs/adr/pwsh/announce-state-changes.md#rule-adr-pwsh-announce1)
        [comment:26](/docs/references/automation/internal/Catzc.Internal.Importer.psm1.md#comment26)
    #>
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('Measure-NoRawConsoleWrite', '', Justification = 'The one sanctioned console-property assignment (ADR-PWSH-ANNOUNCE#1): UTF-8 output for a redirected session, announced by Invoke-Importer on its load record.')]
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
    Reads the $global:__CatzcLoadTimings collector Invoke-Importer creates under -DiagnoseLoadTime and the Bootstrap...
    [comment:27](/docs/references/automation/internal/Catzc.Internal.Importer.psm1.md#comment27)
#>
function Invoke-TypeCacheJanitor {
    <#
    .SYNOPSIS
        Runs the post-import type-cache janitor (Clear-ModuleTypeCache) without ever failing the load.
    .DESCRIPTION
        -Silent unless -ShowReport (the importer passes its -Verbose); CI self-skips inside Clear-ModuleTypeCache.
        [ADR-AUTO-TYPES#13](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types13)
        [comment:28](/docs/references/automation/internal/Catzc.Internal.Importer.psm1.md#comment28)
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

function Invoke-AgentHookJanitor {
    <#
    .SYNOPSIS
        Publishes the agent Bash time-safeguard hook when its C# source changed, without ever failing the load.
    .DESCRIPTION
        Build-BashTimeoutHook is a no-op while the published hook matches its source.
        [ADR-AUTO-FAILFAST#7](/docs/adr/automation/fail-fast-with-asserts.md#rule-adr-auto-failfast7)
        [comment:29](/docs/references/automation/internal/Catzc.Internal.Importer.psm1.md#comment29)
    #>
    [CmdletBinding()]
    param()

    if (-not (Get-Command Build-BashTimeoutHook -ErrorAction Ignore) -or (Get-SessionActor) -eq 'Pipeline' -or
        -not (Test-Path -LiteralPath (Join-Path $env:RepositoryRoot '.claude/hooks/Assert-BashTimeout'))) {
        return
    }
    if (-not (Get-Command dotnet -ErrorAction Ignore)) {
        Write-ImporterMessage 'Agent hook: the Bash time safeguard is not built — dotnet is not on PATH (Install-Dotnet).' -ForegroundColor Yellow
        return
    }
    try {
        $null = Build-BashTimeoutHook
    }
    catch {
        Write-ImporterMessage "Agent hook: the Bash time safeguard was not published — $($_.Exception.Message)" -ForegroundColor Red
    }
}

function Invoke-ImporterJanitors {
    <#
    .SYNOPSIS
        Runs the post-import janitors in their fixed order, from the opt-in deep clean to the commit of what changed.
    .DESCRIPTION
        The tail maintenance of a mono-repo import: the opt-in deep clean first (-CleanClone), then the type-cache...
        [comment:30](/docs/references/automation/internal/Catzc.Internal.Importer.psm1.md#comment30)
    .PARAMETER CleanClone
        Run the whitelisted deep clean (Reset-GitCleanFxd) first, so the janitors below rematerialise what it removed.
    .PARAMETER ShowStateChanges
        Show the type-cache janitor's end-state report (the importer passes its -Verbose).
    #>
    [CmdletBinding()]
    param(
        [switch] $CleanClone,
        [switch] $ShowStateChanges
    )

    # Opt-in deep clean (-CleanClone): the whitelisted git clean -fxd (Reset-GitCleanFxd) deletes only the...
    # [comment:31](/docs/references/automation/internal/Catzc.Internal.Importer.psm1.md#comment31)
    if ($CleanClone -and (Get-Command Reset-GitCleanFxd -ErrorAction Ignore)) {
        Reset-GitCleanFxd
    }

    # Tidy superseded type assemblies (.compiled stays a clean -1/+1 diff) — see Invoke-TypeCacheJanitor.
    Invoke-TypeCacheJanitor -ShowReport:$ShowStateChanges

    # Keep the generated ADR pages current (Catzc.Base.Docs): from adrs.yml and from the glossary sources — committed...
    # [ADR-REPO-README](/docs/adr/repository/generated-readmes.md)
    # [comment:32](/docs/references/automation/internal/Catzc.Internal.Importer.psm1.md#comment32)
    if (Get-Command Build-AdrIndex -ErrorAction Ignore) {
        Build-AdrIndex -Silent | Out-Null
        Build-Glossary -Silent | Out-Null
    }

    # Keep the generated contract pages current (Catzc.Base.Contracts): docs/references/contracts/<unit>.md from the...
    # [ADR-REPO-README](/docs/adr/repository/generated-readmes.md)
    # [comment:33](/docs/references/automation/internal/Catzc.Internal.Importer.psm1.md#comment33)
    if (Get-Command Build-ContractReference -ErrorAction Ignore) {
        Build-ContractReference -Silent | Out-Null
    }

    # Keep the generated README copy-ins current (Catzc.Base.Docs).
    # [comment:34](/docs/references/automation/internal/Catzc.Internal.Importer.psm1.md#comment34)
    if (Get-Command Build-Readme -ErrorAction Ignore) {
        Build-Readme -Silent | Out-Null
    }

    # Keep the managed.gitkeep files current (Catzc.Base.Docs).
    # [ADR-REPO-README](/docs/adr/repository/generated-readmes.md)
    # [comment:35](/docs/references/automation/internal/Catzc.Internal.Importer.psm1.md#comment35)
    if (Get-Command Build-GitKeep -ErrorAction Ignore) {
        Build-GitKeep -Silent | Out-Null
    }

    # Keep the generated cspell dictionaries current (Catzc.Base.QualityGates).
    # [comment:36](/docs/references/automation/internal/Catzc.Internal.Importer.psm1.md#comment36)
    if (Get-Command Build-TerminologyDictionary -ErrorAction Ignore) {
        Build-TerminologyDictionary -Silent | Out-Null
    }

    # Keep the managed root config files current (Catzc.Base.RootConfig).
    # [ADR-REPO-ROOTCFG](/docs/adr/repository/generated-root-configs.md)
    # [comment:37](/docs/references/automation/internal/Catzc.Internal.Importer.psm1.md#comment37)
    if (Get-Command Build-RootConfig -ErrorAction Ignore) {
        Build-RootConfig -Silent | Out-Null
    }

    # Reconcile the session PATH to whatever tools are actually present — including tools installed outside the...
    # [ADR-PWSH-ANNOUNCE#6](/docs/adr/pwsh/announce-state-changes.md#rule-adr-pwsh-announce6),
    # [ADR-PWSH-ANNOUNCE#9](/docs/adr/pwsh/announce-state-changes.md#rule-adr-pwsh-announce9)
    # [comment:38](/docs/references/automation/internal/Catzc.Internal.Importer.psm1.md#comment38)
    if (Get-Command Sync-SessionTools -ErrorAction Ignore) {
        $informationPreference = $global:InformationPreference
        if (-not $ShowStateChanges) {
            $global:InformationPreference = 'SilentlyContinue'
        }
        try {
            Sync-SessionTools
        }
        finally {
            $global:InformationPreference = $informationPreference
        }
    }

    # Publish the agent hook when its source changed — after the PATH reconciliation, so `dotnet` is the owned SDK.
    Invoke-AgentHookJanitor

}

function Write-LoadTime {
    <#
    .SYNOPSIS
        Writes one -DiagnoseLoadTime stage line: the milliseconds since the previous stage, then restarts the clock.
    .DESCRIPTION
        Internal to the importer overlay, called only under -DiagnoseLoadTime, which starts $script:diagSw.
        [ADR-PWSH-CACHE#4](/docs/adr/pwsh/script-scope-caching.md#rule-adr-pwsh-cache4)
        [comment:40](/docs/references/automation/internal/Catzc.Internal.Importer.psm1.md#comment40)
    .PARAMETER Step
        The stage just finished.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Step
    )

    if ($null -eq $ExecutionContext.SessionState.PSVariable.GetValue('script:diagSw')) {
        $script:diagSw = [Diagnostics.Stopwatch]::StartNew()
    }
    Write-ImporterMessage ('{0,6}ms  {1}' -f [int]$script:diagSw.Elapsed.TotalMilliseconds, $Step) -ForegroundColor DarkGray
    $script:diagSw.Restart()
}

function Write-LoadTimeSummary {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidGlobalVars', '', Justification = 'Reads $global:__CatzcLoadTimings, the cross-module load-timing collector Invoke-Importer creates under -DiagnoseLoadTime')]
    [CmdletBinding()]
    param()

    Write-ImporterMessage '  ---- summary ----' -ForegroundColor DarkGray

    # raw-read is a pure [IO.File]::ReadAllText of every.ps1 BEFORE Import-Module, so it isolates the cold file-READ...
    # [comment:41](/docs/references/automation/internal/Catzc.Internal.Importer.psm1.md#comment41)
    $scanMs = [int](($global:__CatzcLoadTimings | Measure-Object ReadMs -Sum).Sum)
    $scanFiles = [int](($global:__CatzcLoadTimings | Measure-Object FileCount -Sum).Sum)
    $parseMs = [int](($global:__CatzcLoadTimings | Measure-Object ImportMs -Sum).Sum)
    Write-ImporterMessage ('  file-read I/O (cold; warm-cached after 1st access): {0}ms across {1} .ps1 files' -f $scanMs, $scanFiles) -ForegroundColor DarkGray
    Write-ImporterMessage ('  Import-Module parse/compile (incl. any AV/AMSI scan-on-parse): {0}ms' -f $parseMs) -ForegroundColor DarkGray
    # The native C# type compile/load (every module's types/*.cs via Import-CSharpTypes) appears as one 'types...
    # [comment:42](/docs/references/automation/internal/Catzc.Internal.Importer.psm1.md#comment42)
    $top = $global:__CatzcLoadTimings | Sort-Object Ms -Descending | Select-Object -First 3
    foreach ($t in $top) {
        Write-ImporterMessage ('  slowest: {0,6}ms  {1}' -f $t.Ms, $t.Stage) -ForegroundColor DarkGray
    }
}

Export-ModuleMember -Function Invoke-Importer
