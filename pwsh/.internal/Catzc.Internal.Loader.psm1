# The always-loaded entry to .internal: the shared code both the bootstrap and the catzc modules call.
Set-StrictMode -Version Latest   # this module's scope: every function here runs strict

$script:internalRoot = $PSScriptRoot

# Idempotent, so a hot-path cover function pays nothing; only the importer's first load passes -Force.
function Import-InternalModule {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('Measure-AnnounceStateChange', '',
        Justification = 'The loader runs before any writer exists; Invoke-Importer announces the internal modules it loads (its Roots line), and a post-import call is the idempotent no-op')]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Name,

        [switch] $Force
    )

    $moduleName = "Catzc.Internal.$Name"
    if (-not $Force -and (Get-Module $moduleName)) {
        return
    }
    Import-Module (Join-Path $script:internalRoot "$moduleName.psm1") -Scope Global -Force
}

# In the always-loaded loader, so the bootstrap pre-pass and every module ask the same function.
function Test-IsRunningInPipeline {
    [CmdletBinding()]
    [OutputType([bool])]
    param()

    # Azure DevOps sets TF_BUILD, GitHub Actions sets GITHUB_ACTIONS.
    [bool]$env:TF_BUILD -or [bool]$env:GITHUB_ACTIONS
}

# VS Code marks every terminal it opens, the PowerShell extension's own included; this is the one reader of that mark.
function Test-IsRunningInVsCode {
    [CmdletBinding()]
    [OutputType([bool])]
    param()

    $env:TERM_PROGRAM -eq 'vscode'
}

# A -File, -Command or -NonInteractive host exits when its command ends and never shows a prompt, unless -NoExit keeps it.
function Test-IsInteractiveHost {
    [CmdletBinding()]
    [OutputType([bool])]
    param(
        [string[]] $CommandLine = [System.Environment]::GetCommandLineArgs()
    )

    $exits = $false
    $noExit = $false
    foreach ($argument in @($CommandLine | Select-Object -Skip 1)) {
        if (-not ($argument.StartsWith('-') -or $argument.StartsWith('/'))) {
            continue
        }
        $name = $argument.TrimStart('-', '/').Split(':')[0].ToLowerInvariant()
        if ($name.Length -eq 0) {
            continue
        }
        if ($name.Length -ge 3 -and 'noexit'.StartsWith($name)) {
            $noExit = $true
        }
        elseif ($name.Length -ge 4 -and 'noninteractive'.StartsWith($name)) {
            $exits = $true
        }
        elseif ('file'.StartsWith($name) -or 'command'.StartsWith($name) -or 'encodedcommand'.StartsWith($name) -or
            $name -eq 'ec') {
            # Everything after the script or the command belongs to it, not to the host.
            $exits = $true
            break
        }
    }
    $noExit -or -not $exits
}

$script:deferredJanitors = $null

# The first prompt renders untouched; the second runs the janitors and restores the prompt.
function Enable-DeferredJanitors {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '',
        Justification = 'Installs an in-memory prompt hook for this session; nothing outside the session changes')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('Measure-AnnounceStateChange', '',
        Justification = 'The hook is session state the importer records in its load record; the janitors announce their own changes when they run')]
    [CmdletBinding()]
    param(
        [scriptblock] $Action,

        [switch] $ShowStateChanges
    )

    if (-not $Action) {
        $show = [bool] $ShowStateChanges
        $Action = {
            Import-InternalModule Importer -Force
            try {
                & (Get-Module Catzc.Internal.Importer) { param($showStateChanges) Invoke-ImporterJanitors -ShowStateChanges:$showStateChanges } $show
            }
            finally {
                Remove-Module Catzc.Internal.Importer -Force -ErrorAction SilentlyContinue
            }
        }.GetNewClosure()
    }

    $previous = $null
    $existing = Get-Command prompt -CommandType Function -ErrorAction Ignore
    if ($existing) {
        $previous = $existing.ScriptBlock
    }
    $script:deferredJanitors = @{ Action = $Action; Previous = $previous; Rendered = 0 }
    Set-Item -Path function:global:prompt -Value { Invoke-DeferredJanitorsPrompt }
}

function Invoke-DeferredJanitorsPrompt {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '',
        Justification = 'Restores the prompt the hook replaced; session state only')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('Measure-AnnounceStateChange', '',
        Justification = 'Undoes the hook Enable-DeferredJanitors installed; the janitors announce their own changes')]
    [CmdletBinding()]
    [OutputType([string])]
    param()

    $state = $script:deferredJanitors
    if (-not $state) {
        return "PS $($ExecutionContext.SessionState.Path.CurrentLocation)$('>' * ($NestedPromptLevel + 1)) "
    }
    $state.Rendered++
    if ($state.Rendered -ge 2) {
        # Restore first, so a janitor that throws leaves a working prompt behind.
        if ($state.Previous) {
            Set-Item -Path function:global:prompt -Value $state.Previous
        }
        else {
            Remove-Item -Path function:global:prompt -ErrorAction Ignore
        }
        $script:deferredJanitors = $null
        & $state.Action
    }
    if ($state.Previous) {
        & $state.Previous
    }
    else {
        "PS $($ExecutionContext.SessionState.Path.CurrentLocation)$('>' * ($NestedPromptLevel + 1)) "
    }
}

# The importer's one writer before Write-Message exists, silent during a Pester run.
function Write-ImporterMessage {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidGlobalVars', '',
        Justification = '$global:__PesterRunning (set by Test-Automation) silences the chokepoint during a test run, as in Write-InformationColored; global is required to cross module session-state boundaries')]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [AllowEmptyString()]
        [string] $Message,

        [System.ConsoleColor] $ForegroundColor,

        [switch] $StateChange
    )

    # Read through Get-Variable: the flag is unset outside a test run, and strict mode rejects an unset variable.
    if (Get-Variable -Name '__PesterRunning' -Scope Global -ValueOnly -ErrorAction Ignore) {
        return
    }
    $line = if ($Message) {
        "[Importer.ps1] $Message"
    }
    else {
        ''
    }
    if ($StateChange) {
        Write-Verbose $line -Verbose:$script:importerVerbose
        return
    }
    if ($PSBoundParameters.ContainsKey('ForegroundColor')) {
        # $PSStyle, not the Writers' Ansi type: this runs before the combined types assembly is loaded.
        $line = "$($PSStyle.Foreground.FromConsoleColor($ForegroundColor))$line$($PSStyle.Reset)"
    }
    Write-Information $line -InformationAction Continue
}

# Module state, living as long as the loader: a fresh import starts it at $false.
$script:importerVerbose = $false

# The bootstrap and vendor functions do not inherit -Verbose, so Invoke-Importer hands the setting over here once.
function Set-ImporterVerbosity {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '',
        Justification = 'Sets a bootstrap-private output flag for the duration of one import; nothing to confirm')]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [bool] $Enabled
    )

    $script:importerVerbose = $Enabled
}

$script:deferredModules = @{}
$script:firstUseIndex = [System.Collections.Generic.Dictionary[string, string]]::new([System.StringComparer]::OrdinalIgnoreCase)
$script:firstUseBusy = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
$script:firstUseCompletionOriginal = $null
. (Join-Path $PSScriptRoot 'assets/importer/Enable-FirstUseCompletion.ps1')

# The one global import of a module manifest, used at import and at first use, so both load the same files in the same order.
function Import-ModuleManifest {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '',
        Justification = 'Loads a module into the session; the importer announces the load')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('Measure-AnnounceStateChange', '',
        Justification = 'The importer announces the modules it loads (its Loaded line); a first-use load is the same import')]
    [CmdletBinding()]
    [OutputType([System.Management.Automation.PSModuleInfo])]
    param(
        [Parameter(Mandatory)]
        [string] $Path
    )

    $module = Import-Module $Path -Scope Global -Force -PassThru | Select-Object -First 1
    . $module { Set-StrictMode -Version Latest }
    $module
}

function Register-DeferredModule {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '',
        Justification = 'Records in-memory session state only; the importer announces the deferral')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('Measure-AnnounceStateChange', '',
        Justification = 'Records session state the importer announces in its load record')]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string] $Name,

        [Parameter(Mandatory)]
        [string] $ManifestPath,

        [Parameter(Mandatory)]
        [AllowEmptyCollection()]
        [string[]] $CommandName
    )

    Remove-DeferredModule -Name $Name
    $script:deferredModules[$Name] = @{ ManifestPath = $ManifestPath; CommandName = $CommandName }
    foreach ($command in $CommandName) {
        $script:firstUseIndex[$command] = $Name
    }
}

# Strikes a module's names from the index, but only those it still owns.
function Remove-DeferredModule {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '',
        Justification = 'Edits in-memory session state only')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('Measure-AnnounceStateChange', '',
        Justification = 'Edits session state the importer announces in its load record')]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string] $Name
    )

    if (-not $script:deferredModules.ContainsKey($Name)) {
        return
    }
    foreach ($command in $script:deferredModules[$Name].CommandName) {
        $owner = $null
        if ($script:firstUseIndex.TryGetValue($command, [ref] $owner) -and $owner -ieq $Name) {
            [void] $script:firstUseIndex.Remove($command)
        }
    }
    $script:deferredModules.Remove($Name)
}

function Import-DeferredModule {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '',
        Justification = 'Loads a module the importer registered; the load is the first use the importer announced')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('Measure-AnnounceStateChange', '',
        Justification = 'The importer announces the deferral; the load is that deferral resolving')]
    [CmdletBinding(DefaultParameterSetName = 'Name')]
    [OutputType([void])]
    param(
        [Parameter(Mandatory, ParameterSetName = 'Name')]
        [string] $Name,

        [Parameter(Mandatory, ParameterSetName = 'All')]
        [switch] $All
    )

    $names = @(if ($All) {
            $script:deferredModules.Keys
        }
        else {
            $Name
        })
    foreach ($moduleName in $names) {
        if (-not $script:deferredModules.ContainsKey($moduleName)) {
            continue
        }
        # Taken out first, so a lookup from inside this module's own load finds nothing to load again.
        $entry = $script:deferredModules[$moduleName]
        $script:deferredModules.Remove($moduleName)
        try {
            [void] (Import-ModuleManifest -Path $entry.ManifestPath)
        }
        catch {
            $script:deferredModules[$moduleName] = $entry
            throw
        }
        foreach ($command in $entry.CommandName) {
            $owner = $null
            if ($script:firstUseIndex.TryGetValue($command, [ref] $owner) -and $owner -ieq $moduleName) {
                [void] $script:firstUseIndex.Remove($command)
            }
        }
    }
}

function Test-DeferredTypesPending {
    [CmdletBinding()]
    [OutputType([bool])]
    param()

    $records = Get-Variable -Name '__CatzcDeferredTypes' -Scope Global -ValueOnly -ErrorAction Ignore
    if ($records) {
        foreach ($entry in $records.Values) {
            if (-not $entry.Loaded) {
                return $true
            }
        }
    }
    $false
}

# What a hit does: the pending types first (a typed parameter resolves before a body runs), then the owning module.
function Invoke-FirstUseLoad {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '',
        Justification = 'Loads what the importer deferred; session state only')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('Measure-AnnounceStateChange', '',
        Justification = 'The importer announced the deferral; this is it resolving')]
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(Mandatory)]
        [string] $CommandName
    )

    # A lookup from inside the load of the same name must not loop.
    if (-not $script:firstUseBusy.Add($CommandName)) {
        return
    }
    try {
        if (Test-DeferredTypesPending) {
            Initialize-Types | Out-Null
        }
        $owner = $null
        if ($script:firstUseIndex.TryGetValue($CommandName, [ref] $owner) -and $owner) {
            Import-DeferredModule -Name $owner
        }
        if (-not (Test-DeferredTypesPending)) {
            foreach ($command in @($script:firstUseIndex.Keys)) {
                if ($script:firstUseIndex[$command] -eq '') {
                    [void] $script:firstUseIndex.Remove($command)
                }
            }
        }
        if ($script:firstUseIndex.Count -eq 0) {
            $ExecutionContext.InvokeCommand.PreCommandLookupAction = $null
            Enable-FirstUseCompletion -Remove
        }
    }
    finally {
        [void] $script:firstUseBusy.Remove($CommandName)
    }
}

# Installed last: with a deferred module registered, a compiled filter, since a script hook costs 12 to 14 microseconds on every command lookup of the session.
function Enable-FirstUseHook {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '',
        Justification = 'Installs an in-memory lookup hook for this session only; the importer announces the deferral')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('Measure-AnnounceStateChange', '',
        Justification = 'The hook is session state the importer records in its load record')]
    [CmdletBinding()]
    [OutputType([void])]
    param(
        # Commands that wait only on the pending types: they load the types and no module.
        [AllowEmptyCollection()]
        [string[]] $TypesCommandName = @()
    )

    if (Test-DeferredTypesPending) {
        foreach ($command in $TypesCommandName) {
            if (-not $script:firstUseIndex.ContainsKey($command)) {
                $script:firstUseIndex[$command] = ''
            }
        }
    }
    if ($script:firstUseIndex.Count -eq 0) {
        $ExecutionContext.InvokeCommand.PreCommandLookupAction = $null
        Enable-FirstUseCompletion -Remove
        return
    }

    if ($script:deferredModules.Count -eq 0) {
        Enable-FirstUseCompletion -Remove
        $ExecutionContext.InvokeCommand.PreCommandLookupAction = {
            param($lookedUp)
            if ($script:firstUseIndex.ContainsKey($lookedUp)) {
                Invoke-FirstUseLoad -CommandName $lookedUp
            }
        }
        return
    }

    Enable-FirstUseCompletion
    $action = [System.Action[string]] { param($lookedUp) Invoke-FirstUseLoad -CommandName $lookedUp }
    $expression = [System.Linq.Expressions.Expression]
    $handlerType = [System.EventHandler[System.Management.Automation.CommandLookupEventArgs]]
    $indexType = $script:firstUseIndex.GetType()
    $origin = $expression::Parameter([object], 'origin')
    $lookup = $expression::Parameter([System.Management.Automation.CommandLookupEventArgs], 'lookup')
    $name = $expression::Property($lookup, 'CommandName')
    $hit = $expression::Call($expression::Constant($script:firstUseIndex, $indexType), $indexType.GetMethod('ContainsKey'), $name)
    $load = $expression::Call($expression::Constant($action, [System.Action[string]]), [System.Action[string]].GetMethod('Invoke'), $name)
    $filter = $expression::Lambda($handlerType, $expression::IfThen($hit, $load), [System.Linq.Expressions.ParameterExpression[]] @($origin, $lookup)).Compile()
    $ExecutionContext.InvokeCommand.PreCommandLookupAction = $filter
}

Export-ModuleMember -Function Import-InternalModule, Test-IsRunningInPipeline, Test-IsRunningInVsCode, Test-IsInteractiveHost, Enable-DeferredJanitors, Invoke-DeferredJanitorsPrompt, Write-ImporterMessage, Set-ImporterVerbosity, Import-ModuleManifest, Register-DeferredModule, Import-DeferredModule, Remove-DeferredModule, Enable-FirstUseHook, Enable-FirstUseCompletion
