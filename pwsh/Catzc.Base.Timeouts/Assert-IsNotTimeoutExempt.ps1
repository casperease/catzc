<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.Timeouts/Assert-IsNotTimeoutExempt.ps1
    name: assert-is-not-timeout-exempt
    filetype: ps1
    role: function
    subkind: assert
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.Timeouts
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: pwsh/Catzc.Base.Timeouts/tests/Assert-IsNotTimeoutExempt.Tests.ps1
    docs: "[Assert-IsNotTimeoutExempt.ps1.md](docs/references/pwsh/catzc-base-timeouts/Assert-IsNotTimeoutExempt.ps1.md)"
---
#>

function Assert-IsNotTimeoutExempt {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [guid] $Budget,
        [ArgumentCompleter({ [Catzc.Base.Engines.ExecutionEngines]::Names })]
        [string] $Shell = [Catzc.Base.Engines.ExecutionEngines]::Pwsh.Name
    )

    $exemption = Get-TimeoutExemption $Budget -Shell $Shell
    if ($exemption) {
        throw "Budget '$Budget' is exempt from its time limit here ($($exemption.reason)); remove the exemption from timeout-exemptions.yml"
    }
}
