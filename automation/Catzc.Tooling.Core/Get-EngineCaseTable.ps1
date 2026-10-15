<#
---
catzc:
  derived:
    path: automation/Catzc.Tooling.Core/Get-EngineCaseTable.ps1
    kind: public-function
    module: Catzc.Tooling.Core
    visibility: public
    adrs:
      - ADR-AUTO-ENGINE#1
---
#>

<#
.SYNOPSIS
    Loads a per-engine fixture table: one row per case and execution engine (ExecutionEngines), validated.
.DESCRIPTION
    A case that skips an engine must say why ("n/a: reason"), so a missing engine cell can never hide a parity gap.
.PARAMETER Path
    The table file: absolute, or relative to the repository root (never to the current directory).
.PARAMETER Engine
    Return only this engine's rows.
.PARAMETER Applicable
    Return only the rows that apply (skip the "n/a" cells).
.OUTPUTS
    [hashtable] One per case and engine, in file order.
.EXAMPLE
    Get-EngineCaseTable automation/Catzc.Base.Timeouts/tests/assets/engine-cases/bounded-command.yml -Applicable
#>
function Get-EngineCaseTable {
    [CmdletBinding()]
    [OutputType([hashtable])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Path,
        [ArgumentCompleter({ [Catzc.Base.Engines.ExecutionEngines]::Names })]
        [string] $Engine,
        [switch] $Applicable
    )

    # Validate the filter first: a mistyped engine name throws and lists the valid ones, not an empty result.
    # [comment:2](/docs/references/automation/catzc-tooling-core/Get-EngineCaseTable.ps1.md#comment2)
    if ($Engine) {
        $null = [Catzc.Base.Engines.ExecutionEngines]::Get($Engine)
    }

    $file = if ([System.IO.Path]::IsPathRooted($Path)) {
        $Path
    }
    else {
        Resolve-RepoPath $Path
    }
    Assert-PathExist $file -PathType Leaf
    $table = [Catzc.Tooling.Core.EngineCaseTable]::new((Get-Content -LiteralPath $file -Raw | ConvertFrom-Yaml -Ordered))
    foreach ($row in $table.Rows) {
        if ($Engine -and $row.engine -ne $Engine) {
            continue
        }
        if ($Applicable -and $row.not_applicable) {
            continue
        }
        @{
            Case          = $row.case
            Engine        = $row.engine
            Fields        = $row.fields
            NotApplicable = $row.not_applicable
        }
    }
}
