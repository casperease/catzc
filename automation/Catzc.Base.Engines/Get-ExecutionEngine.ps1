<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Engines/Get-ExecutionEngine.ps1
    kind: function
    language: powershell
    filekind: ps1
    track: automation
    module: Catzc.Base.Engines
    visibility: public
    relatives:
      test: automation/Catzc.Base.Engines/tests/Get-ExecutionEngine.Tests.ps1
    adrs:
      - ADR-AUTO-ENGINE
  config:
    synopsis: Returns the repository's execution engines, or one by name.
    description: |-
      The repository's own code runs under exactly three execution engines, pwsh, bash and zsh, declared once in the
      ExecutionEngines model ([ADR-AUTO-ENGINE](/docs/adr/automation/execution-engines.md)): each names how its
      executable is located, which scripts it runs, how it starts non-interactively, how it loads an entry script and
      runs a command (StartArguments), its strict mode, its time safeguard, the line endings and executable bit its
      scripts need, and its importer entry. A caller reads what differs between the engines here instead of restating
      it.
    parameters:
      Name: The engine's name (pwsh, bash or zsh). Omit for every engine, pwsh first.
    outputs: '[Catzc.Base.Engines.ExecutionEngine]'
    examples:
      - (Get-ExecutionEngine -Name bash).StartArguments('importer.sh', 'get-widget')
      - Get-ExecutionEngine | Select-Object Name, ImporterEntry, StrictMode
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
