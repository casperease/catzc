<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.Repository/Test-IsRunningAsAgent.ps1
    name: test-is-running-as-agent
    filetype: ps1
    role: function
    subkind: gate
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.Repository
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: pwsh/Catzc.Base.Repository/tests/Test-IsRunningAsAgent.Tests.ps1
    docs: "[Test-IsRunningAsAgent.ps1.md](docs/references/pwsh/catzc-base-repository/Test-IsRunningAsAgent.ps1.md)"
---
#>

function Test-IsRunningAsAgent {
    [CmdletBinding()]
    [OutputType([bool])]
    param()

    [bool]$env:CLAUDECODE -or [bool]$env:AI_AGENT
}
