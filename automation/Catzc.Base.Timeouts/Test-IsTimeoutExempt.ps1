<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Timeouts/Test-IsTimeoutExempt.ps1
    kind: gate-function
    module: Catzc.Base.Timeouts
    visibility: public
    relatives:
      test: automation/Catzc.Base.Timeouts/tests/Test-IsTimeoutExempt.Tests.ps1
  config:
    synopsis: Tests whether a budget GUID is exempt from its normal time limit in this run environment.
    description: The boolean form of Get-TimeoutExemption, which defines the lookup.
    parameters:
      Budget: The budget's immutable GUID.
      Shell: The shell the work runs in, one of the execution engines (pwsh, bash or zsh); pwsh is the default.
    examples:
      - if (Test-IsTimeoutExempt $budget) { Write-Message 'running exempt while tuned' }
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
