function Format-Links {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [Catzc.Base.Asserts.ValidatePathGiven()]
        [string[]] $Path,

        [Catzc.Base.QualityGates.LinkKind] $Kind = [Catzc.Base.QualityGates.LinkKind]::Both,

        [Catzc.Base.QualityGates.LinkWrap] $Wrap = (Get-Config -Config links).wrap,

        [string] $RepositoryRoot = (Get-RepositoryRoot),

        [string] $MoveMap,

        [switch] $DryRun,

        [switch] $PassThru
    )

    Assert-SourceTree

    $stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
    $utf8NoBom = [System.Text.UTF8Encoding]::new($false)
    # A move map re-points every link a move broke before the links are aligned, so one pass leaves them both resolving and aligned.
    $repointed = [string[]] @()
    if ($MoveMap) {
        Assert-PathExist $MoveMap -PathType Leaf
        $map = [ordered]@{}
        foreach ($row in @(Import-Csv -LiteralPath $MoveMap)) {
            Assert-True ($row.old -and $row.new) -ErrorText "Format-Links: the move map '$MoveMap' needs an old and a new column on every row."
            $map[$row.old] = $row.new
        }
        $moved = Update-MovedLinks -RepositoryRoot $RepositoryRoot -File ([string[]] @(Get-LinkScope -RepositoryRoot $RepositoryRoot -Path $Path)) -Map $map
        $repointed = [string[]] @($moved.Keys | Sort-Object)
        if (-not $DryRun) {
            foreach ($file in $repointed) {
                [System.IO.File]::WriteAllText((Join-Path $RepositoryRoot $file), $moved[$file], $utf8NoBom)
            }
        }
        $verb = $DryRun ? 'would re-point' : 're-pointed'
        Write-Message "Links: $verb the links of $($repointed.Count) file(s) to $($map.Count) moved path(s)."
    }
    $result = Invoke-LinkEngine -RepositoryRoot $RepositoryRoot -Path $Path -Kind $Kind -Wrap $Wrap

    $changedFiles = [string[]] @($result.Changed.Keys | Sort-Object)
    if (-not $DryRun) {
        foreach ($file in $changedFiles) {
            [System.IO.File]::WriteAllText((Join-Path $RepositoryRoot $file), $result.Changed[$file], $utf8NoBom)
        }
    }
    $stopwatch.Stop()

    $fixed = @($result.Findings | Where-Object { $_.IsFixable })
    $unfixable = @($result.Findings | Where-Object { -not $_.IsFixable -and $_.IsViolation })
    $verb = if ($DryRun) {
        'would align'
    }
    else {
        'aligned'
    }
    $elapsed = "$($stopwatch.ElapsedMilliseconds) ms"
    $needPerson = "$($unfixable.Count) need a person (run Test-Links to list them)"
    if ($fixed.Count -eq 0 -and $unfixable.Count -eq 0) {
        Write-Message "Links: all $($result.FileCount) file(s) already aligned ($elapsed)."
    }
    elseif ($fixed.Count -eq 0) {
        Write-Message "Links: nothing to align in $($result.FileCount) file(s) ($elapsed); $needPerson."
    }
    elseif ($unfixable.Count -eq 0) {
        Write-Message "Links: $verb $($fixed.Count) link(s) in $($changedFiles.Count) of $($result.FileCount) file(s) ($elapsed)."
    }
    else {
        Write-Message "Links: $verb $($fixed.Count) link(s) in $($changedFiles.Count) of $($result.FileCount) file(s) ($elapsed); $needPerson."
    }

    if ($PassThru) {
        return [pscustomobject]@{
            ChangedCount = $changedFiles.Count
            ChangedFiles = $changedFiles
            Repointed    = $repointed
            Fixed        = $fixed
            Unfixable    = $unfixable
            DryRun       = [bool] $DryRun
            ElapsedMs    = $stopwatch.ElapsedMilliseconds
        }
    }
    $changedFiles
}
