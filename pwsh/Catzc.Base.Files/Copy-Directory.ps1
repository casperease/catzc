<#
---
catzc:
  immutable:
    with_body_sha: "2e1d90ba20b2"
  edges:
    test: pwsh/Catzc.Base.Files/tests/Copy-Directory.Tests.ps1
    docs: "[Copy-Directory.ps1.md](../../docs/references/pwsh/catzc-base-files/Copy-Directory.ps1.md)"
    cites:
      - ADR-PWSH-ENUM-ALWAYSBOUNDED
---
#>

function Copy-Directory {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Path,

        [Parameter(Mandatory, Position = 1)]
        [string] $Destination
    )

    $source = [System.IO.Path]::GetFullPath($Path)
    Assert-PathExist $source -PathType Container -ErrorText "Copy-Directory: source directory '$Path' does not exist."
    $target = [System.IO.Path]::GetFullPath($Destination)
    $sourceLen = $source.Length

    [System.IO.Directory]::CreateDirectory($target) | Out-Null

    foreach ($dir in Get-ChildPath $source -Directory -Depth 64 -Exclude @() -PruneVendor $false) {
        [System.IO.Directory]::CreateDirectory($target + $dir.Substring($sourceLen)) | Out-Null
    }
    foreach ($file in Get-ChildPath $source -File -Depth 64 -Exclude @() -PruneVendor $false) {
        [System.IO.File]::Copy($file, $target + $file.Substring($sourceLen), $true)
    }
}
