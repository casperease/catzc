<#
.SYNOPSIS
    Runs a scriptblock while writing progress dots to the console.
.DESCRIPTION
    Wraps a long-running call with a visual heartbeat so the user knows the process is alive.
    [ADR-PWSH-ANNOUNCE#1](/docs/adr/pwsh/announce-state-changes.md#rule-adr-pwsh-announce1)
    [comment:1](/docs/references/automation/catzc-base-execution/Invoke-WithProgress.ps1.md#comment1)
.PARAMETER ScriptBlock
    The work to execute. Runs on the current thread (module scope preserved).
.PARAMETER Message
    Optional prefix written before the dots (e.g., 'Checking tools').
    [comment:2](/docs/references/automation/catzc-base-execution/Invoke-WithProgress.ps1.md#comment2)
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
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'IntervalMs is consumed inside the dot-writer thread job as $using:IntervalMs, which this rule does not trace as a use')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidGlobalVars', '', Justification = '$global:__PesterRunning (set by Test-Automation) is read here and set in the dot job''s own runspace, so the chokepoint guard there matches this session''s; the job''s $global:InformationPreference makes its writes render. Global is required to reach the chokepoint''s module scope')]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [scriptblock] $ScriptBlock,

        [string] $Message,

        [int] $IntervalMs = 1000
    )

    if ($Message) {
        Write-Message $Message -NoHeader -NoNewline
    }

    # The dot writer runs in a thread job with its own runspace: it streams to this host, imports the same Writers...
    # [comment:3](/docs/references/automation/catzc-base-execution/Invoke-WithProgress.ps1.md#comment3)
    $writersPath = (Get-Module Catzc.Base.Writers).Path
    $silenced = [bool](Get-Variable -Name '__PesterRunning' -Scope Global -ValueOnly -ErrorAction Ignore)   # unset outside a test run
    $dotJob = Start-ThreadJob -StreamingHost $Host -ScriptBlock {
        $global:__PesterRunning = $using:silenced
        $global:InformationPreference = 'Continue'
        Import-Module $using:writersPath
        while ($true) {
            Start-Sleep -Milliseconds $using:IntervalMs
            Write-Message '.' -NoHeader -NoNewline
        }
    }

    try {
        # Work runs on the current thread — module scope preserved
        & $ScriptBlock
    }
    finally {
        # Stop and remove without Receive-Job: the dots already streamed, and receiving would replay them.
        # [comment:4](/docs/references/automation/catzc-base-execution/Invoke-WithProgress.ps1.md#comment4)
        $dotJob | Remove-Job -Force
        Write-Message '' -NoHeader
    }
}
