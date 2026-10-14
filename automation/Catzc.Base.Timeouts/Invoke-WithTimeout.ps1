<#
.SYNOPSIS
    Runs a script block inside a time safeguard: past its limit it is stopped and the call throws.
.DESCRIPTION
    Runs the script block in the current runspace — it sees the same functions, modules and variables it would
    see when called directly — and returns its output. A PipelineWatchdog stops it once it outlives the limit,
    including a native command it is waiting on; the call then throws a TimeoutException that names the limit
    and where it comes from. A terminating error inside the block is rethrown as itself; non-terminating errors
    are passed on as errors of this call.
.PARAMETER ScriptBlock
    The work to run.
.PARAMETER Seconds
    The limit in seconds. Defaults to `default_seconds` in timeouts.yml (Get-TimeoutSeconds).
.PARAMETER Activity
    What the work is, for the timeout message. Defaults to the script block's text.
.EXAMPLE
    $tree = Invoke-WithTimeout { Get-ChildItem -Recurse $root } -Seconds 30
.EXAMPLE
    Invoke-WithTimeout { Sync-Widget } -Activity 'widget sync'
#>
function Invoke-WithTimeout {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [scriptblock] $ScriptBlock,

        [ValidateRange(1, [int]::MaxValue)]
        [int] $Seconds = (Get-TimeoutSeconds),

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
            "$Seconds-second limit. Make it faster, or raise the limit: pass -Seconds, or tune default_seconds in " +
            'automation/Catzc.Base.Timeouts/configs/timeouts.yml.'
        )
    }
}
