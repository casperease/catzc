function Get-DrsIndex {
    [OutputType([object[]])]
    [CmdletBinding()]
    param(
        [string] $IndexPath = (Get-Config -Config drs).IndexPath((Get-RepositoryRoot))
    )

    if ($null -eq $ExecutionContext.SessionState.PSVariable.GetValue('script:drsIndexCache')) {
        # Probed strict-clean: an unset script variable reads as null through SessionState instead of throwing.
        $script:drsIndexCache = @{}
    }
    if ($script:drsIndexCache.ContainsKey($IndexPath)) {
        return , $script:drsIndexCache[$IndexPath]
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
    $script:drsIndexCache[$IndexPath] = $ret
    , $ret
}
