function Update-DocSnapshot {
    <#
    .SYNOPSIS
        Moves a session's seen copy forward for the named files, so the next Get-DocChange no longer reports them.

    .DESCRIPTION
        For each repository-relative path: a file on disk is copied into seen/ and its seen.json entry rewritten; a file gone from disk is
        removed from both. baseline/ never moves.

    .PARAMETER Session
        The session folder. Default: the newest session.

    .PARAMETER Path
        The repository-relative paths to move forward; for a rename, both the old and the new path.
    #>
    [CmdletBinding()]
    param(
        [string] $Session,

        [Parameter(Mandatory, Position = 0)]
        [string[]] $Path
    )

    $Session = Resolve-ListenSession $Session
    $watch = ([System.IO.File]::ReadAllText((Join-Path $Session 'manifest.json')) | ConvertFrom-Json).watch
    $indexPath = Join-Path $Session 'seen.json'
    $index = Read-ListenIndex $indexPath
    $root = Get-RepositoryRoot

    foreach ($relative in @($Path | ForEach-Object { $_.Replace('\', '/') })) {
        Assert-True ($relative.StartsWith("$watch/", [StringComparison]::Ordinal)) -ErrorText "Update-DocSnapshot: '$relative' is not under the watched folder '$watch'."
        $live = Join-Path $root $relative
        $seen = Join-Path (Join-Path $Session 'seen') $relative.Substring($watch.Length + 1)
        if ([System.IO.File]::Exists($live)) {
            [void] [System.IO.Directory]::CreateDirectory([System.IO.Path]::GetDirectoryName($seen))
            [System.IO.File]::Copy($live, $seen, $true)
            $info = [System.IO.FileInfo]::new($live)
            $index[$relative] = [ordered]@{
                length = $info.Length
                ticks  = $info.LastWriteTimeUtc.Ticks
                hash   = [Catzc.Base.Globs.DurableHash]::HashFile($live)
            }
        }
        else {
            if ([System.IO.File]::Exists($seen)) {
                [System.IO.File]::Delete($seen)
            }
            $index.Remove($relative)
        }
    }
    Write-ListenIndex $indexPath -Index $index
}
