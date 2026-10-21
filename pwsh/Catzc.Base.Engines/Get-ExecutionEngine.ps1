<#
---
catzc:
  immutable:
    with_body_sha: "1bab01bc5870"
  edges:
    test: pwsh/Catzc.Base.Engines/tests/Get-ExecutionEngine.Tests.ps1
    docs: "[Get-ExecutionEngine.ps1.md](../../docs/references/pwsh/catzc-base-engines/Get-ExecutionEngine.ps1.md)"
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
