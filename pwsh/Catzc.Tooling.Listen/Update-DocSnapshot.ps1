<#
---
catzc:
  immutable:
    with_body_sha: c1d1e3cdd7e5
  edges:
    test: pwsh/Catzc.Tooling.Listen/tests/Update-DocSnapshot.Tests.ps1
    docs: "[Update-DocSnapshot.ps1.md](../../docs/references/pwsh/catzc-tooling-listen/Update-DocSnapshot.ps1.md)"
---
#>

function Update-DocSnapshot {
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
