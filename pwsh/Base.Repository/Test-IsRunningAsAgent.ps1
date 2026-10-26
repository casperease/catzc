<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-repository/Test-IsRunningAsAgent.ps1.md"
  header: "generated"
---
#>

function Test-IsRunningAsAgent {
    [CmdletBinding()]
    [OutputType([bool])]
    param()

    [bool]$env:CLAUDECODE -or [bool]$env:AI_AGENT
}
