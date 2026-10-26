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

    # The engines are declared once, so Get throws, naming them, for any other name.
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
