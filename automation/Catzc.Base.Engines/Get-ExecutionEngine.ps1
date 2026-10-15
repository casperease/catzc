<#
.SYNOPSIS
    Returns the repository's execution engines, or one by name.
.DESCRIPTION
    The repository's own code runs under exactly three execution engines, pwsh, bash and zsh, declared once in the...
    [ADR-AUTO-ENGINE](/docs/adr/automation/execution-engines.md)
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
