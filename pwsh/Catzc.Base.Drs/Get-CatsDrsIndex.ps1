<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-drs/Get-CatsDrsIndex.ps1.md"
  header: "generated"
---
#>

function Get-CatsDrsIndex {
    [OutputType([object[]])]
    [CmdletBinding()]
    param(
        [string] $IndexPath = (Get-Config -Config drs).IndexPath((Get-RepositoryRoot))
    )

    if ($null -eq $ExecutionContext.SessionState.PSVariable.GetValue('script:catsAdrIndexCache')) {
        $script:catsAdrIndexCache = @{}
    }
    if ($script:catsAdrIndexCache.ContainsKey($IndexPath)) {
        return , $script:catsAdrIndexCache[$IndexPath]
    }

    Assert-PathExist $IndexPath

    $row = "^\|\s*``(?<code>$((Get-Config -Config drs).CodeForm.Cited))``\s*\|\s*\[(?<title>[^\]]+)\]\((?<path>[^)]+)\)"
    $lines = [System.IO.File]::ReadAllLines($IndexPath)
    $ret = foreach ($line in $lines) {
        if ($line -notmatch $row) {
            continue
        }
        [pscustomobject]@{
            Code  = $Matches['code']
            Title = $Matches['title']
            Path  = $Matches['path']
        }
    }

    $ret = @($ret)
    $script:catsAdrIndexCache[$IndexPath] = $ret
    , $ret
}
