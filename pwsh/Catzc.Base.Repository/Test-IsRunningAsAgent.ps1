<#
---
catzc:
  immutable:
    with_body_sha: "1f8404c3623d"
  edges:
    test: pwsh/Catzc.Base.Repository/tests/Test-IsRunningAsAgent.Tests.ps1
    docs: "[Test-IsRunningAsAgent.ps1.md](../../docs/references/pwsh/catzc-base-repository/Test-IsRunningAsAgent.ps1.md)"
---
#>

function Test-IsRunningAsAgent {
    [CmdletBinding()]
    [OutputType([bool])]
    param()

    [bool]$env:CLAUDECODE -or [bool]$env:AI_AGENT
}
