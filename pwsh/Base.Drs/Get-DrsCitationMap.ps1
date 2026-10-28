function Get-DrsCitationMap {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Drs.DrsCitationMap])]
    param(
        [string] $RepositoryRoot = (Get-RepositoryRoot)
    )

    $root = [System.IO.Path]::GetFullPath($RepositoryRoot)
    if ($null -eq $ExecutionContext.SessionState.PSVariable.GetValue('script:drsCitationMapCache')) {
        # Probed strict-clean: an unset script variable reads as null through SessionState instead of throwing.
        $script:drsCitationMapCache = @{}
    }
    if ($script:drsCitationMapCache.ContainsKey($root)) {
        return $script:drsCitationMapCache[$root]
    }

    $drs = Get-Config -Config drs
    $records = $drs.Root
    $drsRoot = Join-Path $root $records
    $indexPath = $drs.IndexPath($root)
    Assert-PathExist $indexPath -PathType Leaf

    $entries = @{}
    foreach ($row in (Get-DrsIndex -IndexPath $indexPath)) {
        $recordFile = Join-Path $drsRoot $row.Path
        $entries[$row.Code] = @{
            path  = "$records/" + ($row.Path -replace '\\', '/')
            rules = [string[]] @(Get-DrsRules -DrsPath $recordFile | ForEach-Object Id)
        }
    }

    # A record sits at most three levels below docs/drs (domain, subfolder, file); the fourth level is headroom.
    $documents = foreach ($file in Get-ChildPath $drsRoot -File -Filter '*.md' -Depth 4) {
        [System.IO.Path]::GetRelativePath($root, $file) -replace '\\', '/'
    }

    $map = [Catzc.Base.Drs.DrsCitationMap]::new($entries, @($documents))
    $script:drsCitationMapCache[$root] = $map
    $map
}
