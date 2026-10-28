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
    # A source, such as a commit, has its own index, so its name joins the key.
    $source = Get-RepositoryTextSource
    $key = if ($source) {
        "$IndexPath|source:$($source.Name)"
    }
    else {
        $IndexPath
    }
    if ($script:drsIndexCache.ContainsKey($key)) {
        return , $script:drsIndexCache[$key]
    }

    $text = Read-RepositoryText $IndexPath
    Assert-True ($null -ne $text) -ErrorText "Path does not exist: $IndexPath"

    $row = "^\|\s*``(?<code>$((Get-Config -Config drs).CodeForm.Cited))``\s*\|\s*\[(?<title>[^\]]+)\]\((?<path>[^)]+)\)"
    $lines = $text -split '\r\n|\r|\n'
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
    $script:drsIndexCache[$key] = $ret
    , $ret
}
