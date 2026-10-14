<#
.SYNOPSIS
    Returns the repository's execution engines, or one by name.
.DESCRIPTION
    The repository's own code runs under exactly two execution engines, pwsh and bash, declared once in the
    ExecutionEngines model ([ADR-AUTO-ENGINE](/docs/adr/automation/execution-engines.md)): each names how its
    executable is located, which scripts it runs, how it starts non-interactively, how it loads an entry script and
    runs a command (StartArguments), its strict mode, its time safeguard, the line endings and executable bit its
    scripts need, and its importer entry. A caller reads what differs between the engines here instead of restating
    it.
.PARAMETER Name
    The engine's name (pwsh or bash). Omit for both, pwsh first.
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
