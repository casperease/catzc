<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Timeouts/Get-TimeoutExemption.ps1
    kind: function
    language: powershell
    filekind: ps1
    track: automation
    module: Catzc.Base.Timeouts
    visibility: public
    relatives:
      test: automation/Catzc.Base.Timeouts/tests/Get-TimeoutExemption.Tests.ps1
  config:
    synopsis: Returns the exemption that covers a budget GUID in this run environment, or nothing.
    description: |-
      Looks the budget up in timeout-exemptions.yml for the run environment (Get-RunEnvironment) and shell. An
      exemption raises the budget's limit to its scope's ceiling while the work is tuned; it never removes the limit.
      The result is the normalized entry: kind (single | range), from, to, environments, shells, reason.
    parameters:
      Budget: The budget's immutable GUID — registered in the managed-GUID registry and passed by the call site.
      Shell: |-
        The shell the work runs in, one of the execution engines (pwsh, bash or zsh); pwsh is the default. Any other name
        throws, naming the shells.
      EnvironmentAssertIs: |-
        Pins the expected run environment (Pipeline or Devbox); a different one throws. The guard verifies, it never
        selects.
    outputs: '[hashtable] The covering exemption; nothing when the budget is not exempt here.'
    examples:
      - Get-TimeoutExemption $budget
---
#>

function Get-TimeoutExemption {
    [CmdletBinding()]
    [OutputType([hashtable])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [guid] $Budget,
        [ArgumentCompleter({ [Catzc.Base.Engines.ExecutionEngines]::Names })]
        [string] $Shell = [Catzc.Base.Engines.ExecutionEngines]::Pwsh.Name,
        [ValidateSet('Pipeline', 'Devbox')]
        [string] $EnvironmentAssertIs
    )

    $guard = @{}
    if ($EnvironmentAssertIs) {
        $guard.EnvironmentAssertIs = $EnvironmentAssertIs
    }
    $environment = Get-RunEnvironment @guard
    $exemption = (Get-Config -Config timeout-exemptions).Find($Budget.ToString(), $environment, $Shell)
    if ($exemption) {
        $exemption
    }
}
