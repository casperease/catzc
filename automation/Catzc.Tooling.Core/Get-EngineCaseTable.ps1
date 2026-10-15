<#
.SYNOPSIS
    Loads a per-engine fixture table: one row per case and execution engine (ExecutionEngines), validated.
.DESCRIPTION
    Reads a YAML engine case table and validates it through the EngineCaseTable type: every case fills every engine...
    [comment:1](/docs/references/automation/catzc-tooling-core/Get-EngineCaseTable.ps1.md#comment1)
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

    # The engines are declared once: Get throws, naming them, for any other name.
    # [ADR-AUTO-ENGINE#1](/docs/adr/automation/execution-engines.md#rule-adr-auto-engine1)
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
