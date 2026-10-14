<#
.SYNOPSIS
    Loads a per-engine fixture table: one row per case and execution engine (pwsh, bash), validated.
.DESCRIPTION
    Reads a YAML engine case table and validates it through the EngineCaseTable type: every case fills every engine
    column, or names why it does not apply ("n/a: <reason>"), so the parity of a behaviour across the repository's
    two engines is explicit case by case. Returns one hashtable per case and engine, shaped for Pester's -ForEach
    (Case, Engine, Fields, NotApplicable): Fields is the column's map, NotApplicable the reason when it does not apply.
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
        [ValidateSet('pwsh', 'bash')]
        [string] $Engine,
        [switch] $Applicable
    )

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
