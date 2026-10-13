<#
.SYNOPSIS
    Returns true if the current session is driven by an AI coding agent rather than a person.
.DESCRIPTION
    Detects an agent-run shell by the environment variables the agent sets for the processes it spawns:
    Claude Code sets CLAUDECODE=1, and agent harnesses set AI_AGENT. The distinction is who owns the
    machine's other sessions: a person may stop their own stale processes, an agent must not stop the
    person's — it works with what it loaded itself.
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
