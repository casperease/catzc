function Write-DiagramQueryRows {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory)]
        [AllowEmptyCollection()]
        [string[]] $Stem,

        [Parameter(Mandatory)]
        [string] $RepositoryRoot,

        [Parameter(Mandatory)]
        [string] $Path,

        [Parameter(Mandatory)]
        [string] $Config
    )

    # A C3 or C4 slide stores its level and its point; its cells are the level's query for that point.
    # A flow slide stores its point and the flow lens; its lanes are the reader's rows for the track its files belong to.
    $readers = $null
    $rows = [System.Collections.Generic.List[object]]::new()
    $seen = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::Ordinal)
    foreach ($folderPath in $Stem) {
        $text = Get-DiagramDeclarationText -Stem $folderPath -RepositoryRoot $RepositoryRoot
        if ($null -eq $text) {
            continue
        }
        $declaration = ConvertFrom-Yaml -Yaml $text -Ordered
        $about = if ($declaration -and $declaration.Contains('about')) {
            $declaration['about']
        }
        if (-not $about -or -not $about.Contains('point') -or -not $about['point']) {
            continue
        }
        $point = "$($about['point'])".Trim().Trim('/')
        if ($about.Contains('lens') -and "$($about['lens'])" -ceq 'flow') {
            if (-not $seen.Add("$point|flow")) {
                continue
            }
            if ($null -eq $readers) {
                $kitConfig = ConvertFrom-Yaml -Yaml ([System.IO.File]::ReadAllText($Config)) -Ordered
                $readers = if ($kitConfig.Contains('flow-readers')) {
                    @($kitConfig['flow-readers'].Values)
                }
                else {
                    @()
                }
            }
            $tracks = @($point -split ';' | ForEach-Object { $_.Trim() } | Where-Object { $_ } | ForEach-Object { (Get-Track -Path $_).name } |
                    Select-Object -Unique)
            Assert-True ($tracks.Count -eq 1) -ErrorText "Write-DiagramQueryRows: $folderPath names flow files on the tracks $($tracks -join ', '); a flow point's files share one track."
            $reader = @($readers | Where-Object { "$($_['track'])" -ceq $tracks[0] })
            $command = if ($reader.Count -gt 0) {
                "$($reader[0]['command'])"
            }
            Assert-True ($reader.Count -gt 0 -and (Get-Command $command -ErrorAction Ignore)) -ErrorText "Write-DiagramQueryRows: $folderPath names flow files on the track '$($tracks[0])', whose flow reader '$command' is not declared under flow-readers in $Config or not loaded."
            $rows.Add((& $command -Point $point -RepositoryRoot $RepositoryRoot))
            continue
        }
        $level = "$($about['zoom'])"
        Assert-True ($level -cin 'C3',
            'C4') -ErrorText "Write-DiagramQueryRows: $folderPath names about.point $point at zoom '$level'; a point belongs to a C3 or C4 slide."
        if (-not $seen.Add("$point|$level")) {
            continue
        }
        $rows.Add($(if ($level -ceq 'C3') {
                    Get-DiagramComponentRows -Point $point -RepositoryRoot $RepositoryRoot
                }
                else {
                    Get-DiagramCodeRows -Point $point -RepositoryRoot $RepositoryRoot
                }))
    }

    $utf8 = [System.Text.UTF8Encoding]::new($false)
    [System.IO.Directory]::CreateDirectory([System.IO.Path]::GetDirectoryName($Path)) | Out-Null
    [System.IO.File]::WriteAllText($Path,
        (ConvertTo-Json -InputObject @{ rows = $rows.ToArray() } -Depth 6 -Compress) + "`n", $utf8)
    $Path
}
