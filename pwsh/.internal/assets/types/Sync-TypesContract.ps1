function Sync-TypesContract {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '',
        Justification = 'Writes generated contract files and their machine-local stamp only when the contracts moved; the importer announces it.')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('Measure-AnnounceStateChange', '',
        Justification = 'The caller (Import-CSharpTypes) announces a written contract through the importer messages.')]
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory)]
        [string] $Path,

        [Parameter(Mandatory)]
        [string] $RepositoryRoot,

        # A fresh build writes its contracts whatever the stamp says.
        [switch] $Force
    )

    # The stamp beside the build holds the content hash of the contract files it wrote, so a cache hit whose contracts are
    # unchanged reads only those few files and never derives the surface again.
    $stamp = [System.IO.Path]::ChangeExtension($Path, 'contracts.sha256')
    $hashOf = { param([string[]] $Relative)
        $digest = [System.Security.Cryptography.IncrementalHash]::CreateHash([System.Security.Cryptography.HashAlgorithmName]::SHA256)
        try {
            foreach ($file in $Relative) {
                $digest.AppendData([System.Text.Encoding]::UTF8.GetBytes("$file`n"))
                $full = [System.IO.Path]::Combine($RepositoryRoot, $file)
                if ([System.IO.File]::Exists($full)) {
                    $digest.AppendData([System.IO.File]::ReadAllBytes($full))
                }
                else {
                    $digest.AppendData([System.Text.Encoding]::UTF8.GetBytes("<missing>`n"))
                }
            }
            [System.Convert]::ToHexString($digest.GetHashAndReset()).ToLowerInvariant()
        }
        finally {
            $digest.Dispose()
        }
    }
    if (-not $Force -and [System.IO.File]::Exists($stamp)) {
        $lines = [System.IO.File]::ReadAllLines($stamp)
        if ($lines.Count -gt 1 -and $lines[0] -ceq (& $hashOf ([string[]] $lines[1..($lines.Count - 1)]))) {
            return
        }
    }

    $results = @(Write-TypesContract -Path $Path -RepositoryRoot $RepositoryRoot)
    $root = [System.IO.Path]::GetFullPath($RepositoryRoot)
    $relative = [string[]] @($results | ForEach-Object Path | Where-Object { [System.IO.File]::Exists($_) } | ForEach-Object {
            [System.IO.Path]::GetRelativePath($root, $_) -replace '\\', '/'
        } | Sort-Object -CaseSensitive)
    if ($relative.Count) {
        $tmp = "$stamp.$PID.tmp"
        [System.IO.File]::WriteAllLines($tmp, [string[]] @(& $hashOf $relative) + $relative)
        [System.IO.File]::Move($tmp, $stamp, $true)
    }
    $results
}
