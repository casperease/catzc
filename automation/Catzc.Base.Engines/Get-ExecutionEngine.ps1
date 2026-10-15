<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Engines/Get-ExecutionEngine.ps1
    kind: function
    module: Catzc.Base.Engines
    visibility: public
    adrs:
      - ADR-AUTO-ENGINE
---
#>

<#
.SYNOPSIS
    Returns the repository's execution engines, or one by name.
.DESCRIPTION
    Read what differs between the engines here, not in a caller: flags, quoting and file rules are declared once.
    [comment:1](/docs/references/automation/catzc-base-engines/Get-ExecutionEngine.ps1.md#comment1)
.PARAMETER Name
    The engine's name (pwsh, bash or zsh). Omit for every engine, pwsh first.
.OUTPUTS
    [Catzc.Base.Engines.ExecutionEngine]
.EXAMPLE
    (Get-ExecutionEngine -Name bash).StartArguments('importer.sh', 'get-widget')
.EXAMPLE
    Get-ExecutionEngine | Select-Object Name, ImporterEntry, StrictMode
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
