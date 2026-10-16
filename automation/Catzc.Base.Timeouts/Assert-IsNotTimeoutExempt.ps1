<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.Timeouts/Assert-IsNotTimeoutExempt.ps1
    name: assert-is-not-timeout-exempt
    filetype: ps1
    kind: function
    subkind: assert
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Timeouts
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: automation/Catzc.Base.Timeouts/tests/Assert-IsNotTimeoutExempt.Tests.ps1
  config:
    synopsis: Asserts that a budget GUID runs under its normal time limit here, not an exemption.
    description: |-
      For work that must never run exempt — for example a quality gate in a pipeline, where an exemption would hide
      a regression. Throws naming the exemption's reason when the budget is exempt; Get-TimeoutExemption defines the
      lookup.
    parameters:
      Budget: The budget's immutable GUID.
      Shell: The shell the work runs in, one of the execution engines (pwsh, bash or zsh); pwsh is the default.
    examples:
      - if (Test-IsRunningInPipeline) { Assert-IsNotTimeoutExempt $budget }
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
