<#
.SYNOPSIS
    Returns true if the current session is driven by an AI coding agent rather than a person.
.DESCRIPTION
    Detects an agent-run shell by the environment variables the agent sets for the processes it spawns: Claude Code...
    [comment:1](/docs/references/automation/catzc-base-repository/Test-IsRunningAsAgent.ps1.md#comment1)
.EXAMPLE
    Test-IsRunningAsAgent
.EXAMPLE
    if (-not (Test-IsRunningAsAgent)) { Clear-ModuleTypeCache -StopLockingProcesses }
#>
function Test-IsRunningAsAgent {
    [CmdletBinding()]
    [OutputType([bool])]
    param()

    [bool]$env:CLAUDECODE -or [bool]$env:AI_AGENT
}
