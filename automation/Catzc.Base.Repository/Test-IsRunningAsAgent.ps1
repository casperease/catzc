# catzc:
#   path: automation/Catzc.Base.Repository/Test-IsRunningAsAgent.ps1
#   module: Catzc.Base.Repository
#   visibility: public

<#
.SYNOPSIS
    Returns true if the current session is driven by an AI coding agent rather than a person.
.DESCRIPTION
    An agent must not stop the person's stale sessions, which a person may stop for themselves; this tells them apart.
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
