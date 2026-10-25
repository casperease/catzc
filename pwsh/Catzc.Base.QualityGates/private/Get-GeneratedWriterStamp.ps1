function Get-GeneratedWriterStamp {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [AllowEmptyCollection()]
        [string[]] $InputGlob,

        [AllowEmptyCollection()]
        [string[]] $ChangedPath,

        [Parameter(Mandatory)]
        [string] $RepositoryRoot
    )

    # The stamp of a writer's changed inputs: each one's path, last write and size, or that it is deleted, hashed in path order.
    $patterns = @($InputGlob | Where-Object { $_ } | ForEach-Object { [Catzc.Base.Globs.GlobPattern]::new($_) })
    $lines = foreach ($path in @($ChangedPath | Sort-Object -Unique)) {
        if (-not @($patterns | Where-Object { $_.Matches($path) })) {
            continue
        }
        $file = [System.IO.FileInfo]::new((Join-Path $RepositoryRoot $path))
        if ($file.Exists) {
            "$path|$($file.LastWriteTimeUtc.Ticks)|$($file.Length)"
        }
        else {
            "$path|deleted"
        }
    }
    $bytes = [System.Text.Encoding]::UTF8.GetBytes((@($lines) -join "`n"))
    [System.Convert]::ToHexString([System.Security.Cryptography.SHA256]::HashData($bytes))
}
