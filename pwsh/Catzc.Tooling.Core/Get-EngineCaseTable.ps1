<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Tooling.Core/Get-EngineCaseTable.ps1
    name: get-engine-case-table
    filetype: ps1
    role: function
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Tooling.Core
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: pwsh/Catzc.Tooling.Core/tests/Get-EngineCaseTable.Tests.ps1
    docs: "[Get-EngineCaseTable.ps1.md](docs/references/pwsh/catzc-tooling-core/Get-EngineCaseTable.ps1.md)"
    cites:
      - ADR-AUTO-ENGINE-THREEENGINES
---
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
