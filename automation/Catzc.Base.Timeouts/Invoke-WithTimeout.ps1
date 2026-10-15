<#
.SYNOPSIS
    Runs a script block inside a time safeguard: past its limit it is stopped and the call throws.
.DESCRIPTION
    Runs the script block in the current runspace — it sees the same functions, modules and variables it would see...
    [comment:1](/docs/references/automation/catzc-base-timeouts/Invoke-WithTimeout.ps1.md#comment1)
.PARAMETER ScriptBlock
    The work to run.
.PARAMETER Budget
    The work's immutable budget GUID (registered in the managed-GUID registry).
    [comment:2](/docs/references/automation/catzc-base-timeouts/Invoke-WithTimeout.ps1.md#comment2)
.PARAMETER Seconds
    The limit in seconds.
    [comment:3](/docs/references/automation/catzc-base-timeouts/Invoke-WithTimeout.ps1.md#comment3)
.PARAMETER Activity
    What the work is, for the timeout message. Defaults to the script block's text.
.EXAMPLE
    $tree = Invoke-WithTimeout { Get-ChildItem -Recurse $root } -Seconds 30
.EXAMPLE
    Invoke-WithTimeout { Sync-Widget } -Activity 'widget sync'
.EXAMPLE
    Invoke-WithTimeout { Sync-Widget } -Budget $widgetSyncBudget
#>
function Invoke-WithTimeout {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [scriptblock] $ScriptBlock,

        [guid] $Budget = [guid]::Empty,

        [ValidateRange(1, [int]::MaxValue)]
        [int] $Seconds = (Get-TimeoutSeconds -Budget $Budget),

        [string] $Activity = $ScriptBlock.ToString().Trim()
    )

    $pipeline = [PowerShell]::Create([System.Management.Automation.RunspaceMode]::CurrentRunspace)
    $null = $pipeline.AddScript('param($work) & $work').AddArgument($ScriptBlock)
    $watchdog = [Catzc.Base.Timeouts.PipelineWatchdog]::new($pipeline, [timespan]::FromSeconds($Seconds))
    $stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
    try {
        $pipeline.Invoke()
    }
    catch [System.Management.Automation.MethodInvocationException] {
        # PowerShell.Invoke wraps the block's terminating error; rethrow the error itself.
        throw $_.Exception.InnerException
    }
    finally {
        $watchdog.Dispose()
        foreach ($record in $pipeline.Streams.Error) {
            $PSCmdlet.WriteError($record)
        }
        $pipeline.Dispose()
    }

    if ($watchdog.Fired) {
        throw [System.TimeoutException]::new(
            "Stopped after $([math]::Round($stopwatch.Elapsed.TotalSeconds, 1))s: '$Activity' did not finish within its " +
            "$Seconds-second limit. Make it faster, or raise the limit: pass -Seconds, tune limits.<environment>.pwsh in " +
            'automation/Catzc.Base.Timeouts/configs/timeouts.yml, or pass a -Budget and exempt it in timeout-exemptions.yml ' +
            'while it is tuned.'
        )
    }
}
