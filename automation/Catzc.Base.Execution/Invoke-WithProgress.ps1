<#
.SYNOPSIS
    Runs a scriptblock while writing progress dots to the console.
.DESCRIPTION
    Wraps a long-running call with a visual heartbeat so the user knows
    the process is alive. Dots are written via [Console]::Write on a
    background ThreadJob — this bypasses PowerShell's output streams
    entirely, so the scriptblock's return value passes through
    uncontaminated. The scriptblock itself runs on the current thread,
    preserving module scope and all imported functions.

    Dots stop and a trailing newline is written when the scriptblock
    completes — including when it throws.
.PARAMETER ScriptBlock
    The work to execute. Runs on the current thread (module scope preserved).
.PARAMETER Message
    Optional prefix written before the dots (e.g., 'Checking tools').
    Appears on the same line as the dots.
.PARAMETER IntervalMs
    Milliseconds between dots. Defaults to 1000.
.EXAMPLE
    $status = Invoke-WithProgress { Get-ToolsStatus } -Message 'Checking tools'
    # Console: Checking tools.......
    # $status: the PSCustomObject[] returned by Get-ToolsStatus
.EXAMPLE
    Invoke-WithProgress { Install-Dotnet } -Message 'Installing .NET' -IntervalMs 2000
    # Console: Installing .NET...
.EXAMPLE
    $result = Invoke-WithProgress { Start-Sleep 5; 'done' }
    # Console: .....
    # $result: 'done'
#>
function Invoke-WithProgress {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingWriteHost', '', Justification = 'Progress dots are written via [Console]::Write specifically to bypass PowerShell output streams, so the wrapped scriptblock''s return value passes through uncontaminated; see .DESCRIPTION')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'IntervalMs is consumed inside the dot-writer thread job as $using:IntervalMs, which this rule does not trace as a use')]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [scriptblock] $ScriptBlock,

        [string] $Message,

        [int] $IntervalMs = 1000
    )

    if ($Message) {
        [Console]::Write($Message)
    }

    # Dot-writer runs in a thread job — [Console]::Write is thread-safe
    # and bypasses PowerShell's output streams so dots don't pollute the pipeline.
    $dotJob = Start-ThreadJob -ScriptBlock {
        while ($true) {
            Start-Sleep -Milliseconds $using:IntervalMs
            [Console]::Write('.')
        }
    }

    try {
        # Work runs on the current thread — module scope preserved
        & $ScriptBlock
    }
    finally {
        $dotJob | Stop-Job -PassThru | Remove-Job
        [Console]::WriteLine()
    }
}
