function Get-DrsCitationMap {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Drs.DrsCitationMap])]
    param(
        [string] $RepositoryRoot = (Get-RepositoryRoot)
    )

    $root = [System.IO.Path]::GetFullPath($RepositoryRoot)
    if ($null -eq $ExecutionContext.SessionState.PSVariable.GetValue('script:adrCitationMapCache')) {
        # Probed strict-clean: an unset script variable reads as null through SessionState instead of throwing.
        $script:adrCitationMapCache = @{}
    }
    if ($script:adrCitationMapCache.ContainsKey($root)) {
        return $script:adrCitationMapCache[$root]
    }

    $drs = Get-Config -Config drs
    $records = $drs.Root
    $adrRoot = Join-Path $root $records
    $indexPath = $drs.IndexPath($root)
    Assert-PathExist $indexPath -PathType Leaf

    $entries = @{}
    foreach ($row in (Get-DrsIndex -IndexPath $indexPath)) {
        $adrFile = Join-Path $adrRoot $row.Path
        $entries[$row.Code] = @{
            path  = "$records/" + ($row.Path -replace '\\', '/')
            rules = [string[]] @(Get-DrsRules -DrsPath $adrFile | ForEach-Object Id)
        }
    }

    # An ADR sits at most three levels below docs/drs (domain, subfolder, file); the fourth level is headroom.
    $documents = foreach ($file in Get-ChildPath $adrRoot -File -Filter '*.md' -Depth 4) {
        [System.IO.Path]::GetRelativePath($root, $file) -replace '\\', '/'
    }

    $map = [Catzc.Base.Drs.DrsCitationMap]::new($entries, @($documents))
    $script:adrCitationMapCache[$root] = $map
    $map
}
