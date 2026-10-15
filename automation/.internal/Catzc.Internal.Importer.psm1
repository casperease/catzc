<#
---
catzc:
  derived:
    path: automation/.internal/Catzc.Internal.Importer.psm1
    kind: internal-module
---
#>

# The shim is generated and only delegates here, then removes this module: the load logic has one living copy.
# [comment:1](/docs/references/automation/internal/Catzc.Internal.Importer.psm1.md#comment1)

Set-StrictMode -Version Latest   # this module's scope: every function here runs strict

<#
.SYNOPSIS
    Runs the toolset's whole load sequence — the single living copy of the importer body.
.DESCRIPTION
    The parameter block is asserted to match importer.ps1, which New-Importer generates from it.
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
    The clean keeps and reports any untracked file that is not the automation's to delete.
    [comment:3](/docs/references/automation/internal/Catzc.Internal.Importer.psm1.md#comment3)
.PARAMETER Bundle
    Only the bundle bootstrap passes it, so an inherited CatzcModulesRoot never diverts a mono repo or fixture load.
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

        # Use it to verify a clean rebuild from source; otherwise each type loads from its committed assembly.
        # [comment:5](/docs/references/automation/internal/Catzc.Internal.Importer.psm1.md#comment5)
        [switch] $ClearCompiledTypes,

        # Only the tail maintenance is skipped; type loading still fast-paths on the committed .compiled DLL.
        # [comment:6](/docs/references/automation/internal/Catzc.Internal.Importer.psm1.md#comment6)
        [switch] $SkipJanitors,

        # The regenerating janitors that follow rematerialise what the clean removed, so a clone ends pristine.
        # [comment:7](/docs/references/automation/internal/Catzc.Internal.Importer.psm1.md#comment7)
        [switch] $CleanClone,

        # Forces -SkipJanitors, because a bundle is a read-only install with no git work tree.
        # [comment:8](/docs/references/automation/internal/Catzc.Internal.Importer.psm1.md#comment8)
        [switch] $Bundle
    )

    # The vendor functions use PSResourceGet, which PowerShell first bundled in 7.4.
    # [comment:9](/docs/references/automation/internal/Catzc.Internal.Importer.psm1.md#comment9)
    if ($PSVersionTable.PSVersion -lt [version]'7.4') {
        throw "The Catzc toolset requires PowerShell 7.4 or later (found $($PSVersionTable.PSVersion))."
    }

    # Strict mode
    Set-StrictMode -Version Latest

    # This runs one call below the shim, so an empty ScriptName at stack index 2 means a dot-sourced console.
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
    # Splits the import from the session setup before it and the janitors after it in the console load line.
    # [comment:11](/docs/references/automation/internal/Catzc.Internal.Importer.psm1.md#comment11)
    $importSw = [Diagnostics.Stopwatch]::new()

    if ($DiagnoseLoadTime) {
        $script:diagSw = [Diagnostics.Stopwatch]::StartNew()
        # Collectors the Bootstrap loaders (incl. Import-CSharpTypes) append to, summarized at the end.
        $global:__CatzcLoadTimings = [System.Collections.Generic.List[object]]::new()
    }

    # The session preference is quieted for the import and restored in finally, or Import-Module lists every function.
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

        # The process relays stream UTF-8, so a redirected host must write UTF-8 too or a captured log mixes encodings.
        # [comment:13](/docs/references/automation/internal/Catzc.Internal.Importer.psm1.md#comment13)
        $outputEncodingChanged = Set-RedirectedOutputEncoding

        # The WORKING root (out/, repo-relative paths, git): the shim sets it and the importer only reads it.
        # [comment:14](/docs/references/automation/internal/Catzc.Internal.Importer.psm1.md#comment14)
        $repoRoot = $env:RepositoryRoot
        Write-Verbose "RepositoryRoot: $repoRoot"

        # Config, type and vendor discovery follow this anchor, not RepositoryRoot, which makes catzc relocatable.
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

        # Bootstrap goes at the end, but the loader, Types and Vendor stay so cover functions can reuse them.
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

        # This is the first point Write-ImporterMessage is loaded, so announcement of session changes starts here.
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

        # The compiled type DLLs can be wiped first so the import below rebuilds them from source.
        # [comment:18](/docs/references/automation/internal/Catzc.Internal.Importer.psm1.md#comment18)
        if ($ClearCompiledTypes) {
            Clear-CompiledType -ModulesRoot $modulesRoot
        }

        $importSw.Start()

        Write-Verbose "Discovering modules in: $modulesRoot"
        Import-AllModules -ModulesRoot $modulesRoot -ExportPrivates:$ExportPrivates -DiagnoseLoadTime:$DiagnoseLoadTime -Bundle:$Bundle
        $importSw.Stop()

        # Import-AllModules evicted the other run mode; this proves it before a janitor touches the tree.
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

        # An isolated copy and a bundle skip the whole chain through -SkipJanitors.
        # [comment:20](/docs/references/automation/internal/Catzc.Internal.Importer.psm1.md#comment20)
        if (-not $SkipJanitors) {
            Invoke-ImporterJanitors -CleanClone:$CleanClone -ShowStateChanges:$showStateChanges
        }

        # The permanent fix is a one-time script that writes a local PSModulePath to powershell.config.json.
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

        # Kept until here only for Write-ImporterMessage; the loader, Types and Vendor stay loaded.
        # [comment:22](/docs/references/automation/internal/Catzc.Internal.Importer.psm1.md#comment22)
        Write-Verbose 'Removing Catzc.Internal.Bootstrap module'
        Remove-Module Catzc.Internal.Bootstrap -Force -ErrorAction SilentlyContinue -Verbose:$false

        # Only a console session gets the load timer; scripts add a trap with Write-Exception after the importer.
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
    Every loaded Catzc module must sit under the active CatzcModulesRoot, the predicate the eviction sweep uses.
    [comment:24](/docs/references/automation/internal/Catzc.Internal.Importer.psm1.md#comment24)
.PARAMETER ModulesRoot
    The active code root.
#>
function Invoke-ConsumerOverlay {
    <#
    .SYNOPSIS
        Applies a consumer's overlay at the end of a bundle load, or stops the load when the bundle cannot.
    .DESCRIPTION
        A bundle without the overlay module cannot apply overrides, so the load stops instead of ignoring them.
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
        A redirected host writes the OEM codepage while relays stream UTF-8, which mangled box drawing in logs.
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
    It writes through the transient bootstrap, so it must run while that is still loaded.
    [comment:27](/docs/references/automation/internal/Catzc.Internal.Importer.psm1.md#comment27)
#>
function Invoke-TypeCacheJanitor {
    <#
    .SYNOPSIS
        Runs the post-import type-cache janitor (Clear-ModuleTypeCache) without ever failing the load.
    .DESCRIPTION
        A superseded build it cannot delete is one red line, never a failed load.
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
        A checkout without the hook's code or dotnet is told, never stopped: Install-Dotnet needs this import.
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
        Every janitor is a fast no-op on a clean tree and guarded by presence, so the bootstrap sandbox runs a subset.
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

    # Deliberately the first janitor, so the regenerating ones below rematerialise what it removed in the same run.
    # [comment:31](/docs/references/automation/internal/Catzc.Internal.Importer.psm1.md#comment31)
    if ($CleanClone -and (Get-Command Reset-GitCleanFxd -ErrorAction Ignore)) {
        Reset-GitCleanFxd
    }

    # Tidy superseded type assemblies (.compiled stays a clean -1/+1 diff) — see Invoke-TypeCacheJanitor.
    Invoke-TypeCacheJanitor -ShowReport:$ShowStateChanges

    # Rebuilt before Build-Readme, because the docs/adr README is generated from the index.
    # [comment:32](/docs/references/automation/internal/Catzc.Internal.Importer.psm1.md#comment32)
    if (Get-Command Build-AdrIndex -ErrorAction Ignore) {
        Build-AdrIndex -Silent | Out-Null
        Build-Glossary -Silent | Out-Null
    }

    # The pages are committed so GitHub has them, and come from the contract assets' header comments.
    # [comment:33](/docs/references/automation/internal/Catzc.Internal.Importer.psm1.md#comment33)
    if (Get-Command Build-ContractReference -ErrorAction Ignore) {
        Build-ContractReference -Silent | Out-Null
    }

    # A README is rewritten only when its content differs, compared ignoring EOL, so a clean tree costs few reads.
    # [comment:34](/docs/references/automation/internal/Catzc.Internal.Importer.psm1.md#comment34)
    if (Get-Command Build-Readme -ErrorAction Ignore) {
        Build-Readme -Silent | Out-Null
    }

    # Each .gitkeep copies one shared template, so a template change propagates here on the next import.
    # [comment:35](/docs/references/automation/internal/Catzc.Internal.Importer.psm1.md#comment35)
    if (Get-Command Build-GitKeep -ErrorAction Ignore) {
        Build-GitKeep -Silent | Out-Null
    }

    # The dictionaries are gitignored, since the registry is the source of truth and cspell resolves fixed paths.
    # [comment:36](/docs/references/automation/internal/Catzc.Internal.Importer.psm1.md#comment36)
    if (Get-Command Build-TerminologyDictionary -ErrorAction Ignore) {
        Build-TerminologyDictionary -Silent | Out-Null
    }

    # Each root file is reproduced from one in-repo source of truth and rewritten only on drift.
    # [comment:37](/docs/references/automation/internal/Catzc.Internal.Importer.psm1.md#comment37)
    if (Get-Command Build-RootConfig -ErrorAction Ignore) {
        Build-RootConfig -Silent | Out-Null
    }

    # The importer is dot-sourced, so PATH nudges land in the caller's live session; -Verbose decides if they show.
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
        A call before the clock exists starts it instead of throwing on the unset variable.
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

    # Small here does not mean no antivirus: a parse-time scan lands in parse and compile, not in the raw read.
    # [comment:41](/docs/references/automation/internal/Catzc.Internal.Importer.psm1.md#comment41)
    $scanMs = [int](($global:__CatzcLoadTimings | Measure-Object ReadMs -Sum).Sum)
    $scanFiles = [int](($global:__CatzcLoadTimings | Measure-Object FileCount -Sum).Sum)
    $parseMs = [int](($global:__CatzcLoadTimings | Measure-Object ImportMs -Sum).Sum)
    Write-ImporterMessage ('  file-read I/O (cold; warm-cached after 1st access): {0}ms across {1} .ps1 files' -f $scanMs, $scanFiles) -ForegroundColor DarkGray
    Write-ImporterMessage ('  Import-Module parse/compile (incl. any AV/AMSI scan-on-parse): {0}ms' -f $parseMs) -ForegroundColor DarkGray
    # A compile+load row is a cold Roslyn cache; a cache load row reused the committed .compiled DLL.
    # [comment:42](/docs/references/automation/internal/Catzc.Internal.Importer.psm1.md#comment42)
    $top = $global:__CatzcLoadTimings | Sort-Object Ms -Descending | Select-Object -First 3
    foreach ($t in $top) {
        Write-ImporterMessage ('  slowest: {0,6}ms  {1}' -f $t.Ms, $t.Stage) -ForegroundColor DarkGray
    }
}

Export-ModuleMember -Function Invoke-Importer
