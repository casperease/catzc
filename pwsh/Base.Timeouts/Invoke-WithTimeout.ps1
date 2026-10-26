<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-timeouts/Invoke-WithTimeout.ps1.md"
  header: "generated"
---
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
            'the Catzc.Base.Timeouts timeouts.yml, or pass a -Budget and exempt it in timeout-exemptions.yml ' +
            'while it is tuned.'
        )
    }
}
