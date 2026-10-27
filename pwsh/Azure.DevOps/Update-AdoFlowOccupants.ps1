function Update-AdoFlowOccupants {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([System.Collections.Specialized.OrderedDictionary])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Path,

        [string] $Project = (Get-Config -Config ado)['project'],

        [string] $Organization = (Get-Config -Config ado)['organization'],

        [ValidateRange(1, 1000)]
        [int] $Top = 50,

        [string] $RepositoryRoot = (Get-RepositoryRoot)
    )

    Assert-NotNullOrWhitespace $Project -ErrorText 'Project is required. Set -Project or configure ado.yml.'
    Assert-NotNullOrWhitespace $Organization -ErrorText 'Organization is required. Set -Organization or configure ado.yml.'
    Assert-PathExist $Path -PathType Leaf
    $apiBase = "$($Organization.TrimEnd('/'))/$Project/_apis"

    $lines = [System.Collections.Generic.List[string]]::new([string[]]@([System.IO.File]::ReadAllLines($Path)))
    $about = $lines.IndexOf('about:')
    if ($about -lt 0) {
        throw "$Path has no about: block, so it is no flow declaration."
    }
    # The about block runs to the next top-level key.
    $end = $about + 1
    while ($end -lt $lines.Count -and ($lines[$end] -match '^\s' -or $lines[$end] -eq '')) {
        $end++
    }
    $kept = @($lines.GetRange($about + 1, $end - $about - 1))
    $point = @($kept | Where-Object { $_ -match '^  point:\s*(.+)$' } | ForEach-Object { $Matches[1].Trim() })
    if ($point.Count -eq 0) {
        throw "$Path has no about.point, so it names no pipeline whose environments it could read."
    }

    $runs = @{}
    $getRun = {
        param([string] $RunId)
        if (-not $runs.ContainsKey($RunId)) {
            $runs[$RunId] = Invoke-AdoRestMethod -Uri "$apiBase/build/builds/$($RunId)?api-version=7.1" -UnwrapValue $false
        }
        $runs[$RunId]
    }

    # Each environment's occupant is the commit of its latest successful deployment: a DEPLOY run's through the CI run it names.
    $occupants = [ordered]@{}
    $rows = Get-AdoFlowRows -Point $point[0] -RepositoryRoot $RepositoryRoot
    foreach ($environment in @($rows.lanes | ForEach-Object { $_.environments })) {
        $id = $environment.id
        $record = @(Invoke-AdoRestMethod -Uri "$apiBase/distributedtask/environments?name=$([uri]::EscapeDataString($id))&api-version=7.1") |
            Where-Object { $null -ne $_ -and "$($_.name)" -eq $id } | Select-Object -First 1
        if (-not $record) {
            continue
        }
        $latest = @(Invoke-AdoRestMethod -Uri "$apiBase/distributedtask/environments/$($record.id)/environmentdeploymentrecords?top=$Top&api-version=7.1") |
            Where-Object { $null -ne $_ -and "$($_.result)" -eq 'succeeded' } | Select-Object -First 1
        if (-not $latest) {
            continue
        }
        $commit = Resolve-AdoRunCommit -RunId "$($latest.owner.id)" -GetRun $getRun
        if ($commit) {
            $occupants[$id] = $commit
        }
    }

    $block = [System.Collections.Generic.List[string]]::new()
    for ($i = 0; $i -lt $kept.Count; $i++) {
        if ($kept[$i] -match '^  occupants:') {
            while ($i + 1 -lt $kept.Count -and $kept[$i + 1] -match '^    ') {
                $i++
            }
            continue
        }
        $block.Add($kept[$i])
    }
    while ($block.Count -and $block[$block.Count - 1] -eq '') {
        $block.RemoveAt($block.Count - 1)
    }
    if ($occupants.Count) {
        $block.Add('  occupants:')
        foreach ($key in $occupants.Keys) {
            $block.Add("    ${key}: $($occupants[$key])")
        }
    }
    $before = @($lines.GetRange(0, $about + 1))
    $after = @($lines.GetRange($end, $lines.Count - $end))
    $content = (@($before) + @($block) + @($after)) -join "`n"
    if ($PSCmdlet.ShouldProcess($Path, 'write about.occupants')) {
        $null = Write-FileIfChanged $Path "$content`n"
    }
    $occupants
}
