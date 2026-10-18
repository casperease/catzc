<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.Repository/Test-IsRunningAsAgent.ps1
    name: test-is-running-as-agent
    filetype: ps1
    kind: function
    subkind: gate
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Repository
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: automation/Catzc.Base.Repository/tests/Test-IsRunningAsAgent.Tests.ps1
---
#>

function Test-IsRunningAsAgent {
    [CmdletBinding()]
    [OutputType([bool])]
    param()

    [bool]$env:CLAUDECODE -or [bool]$env:AI_AGENT
}
