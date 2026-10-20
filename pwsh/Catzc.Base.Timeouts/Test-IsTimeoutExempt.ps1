<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.Timeouts/Test-IsTimeoutExempt.ps1
    name: test-is-timeout-exempt
    filetype: ps1
    role: function
    subkind: gate
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.Timeouts
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: pwsh/Catzc.Base.Timeouts/tests/Test-IsTimeoutExempt.Tests.ps1
    docs: "[Test-IsTimeoutExempt.ps1.md](docs/references/pwsh/catzc-base-timeouts/Test-IsTimeoutExempt.ps1.md)"
---
#>

function Test-IsTimeoutExempt {
    [CmdletBinding()]
    [OutputType([bool])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [guid] $Budget,
        [ArgumentCompleter({ [Catzc.Base.Engines.ExecutionEngines]::Names })]
        [string] $Shell = [Catzc.Base.Engines.ExecutionEngines]::Pwsh.Name
    )

    $null -ne (Get-TimeoutExemption $Budget -Shell $Shell)
}
