<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.Engines/Get-ExecutionEngine.ps1
    name: get-execution-engine
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Engines
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: automation/Catzc.Base.Engines/tests/Get-ExecutionEngine.Tests.ps1
    cites:
      - ADR-AUTO-ENGINE
---
#>

function Get-ExecutionEngine {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Engines.ExecutionEngine])]
    param(
        [ArgumentCompleter({ [Catzc.Base.Engines.ExecutionEngines]::Names })]
        [string] $Name
    )

    if ($Name) {
        return [Catzc.Base.Engines.ExecutionEngines]::Get($Name)
    }
    [Catzc.Base.Engines.ExecutionEngines]::All
}
