<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Files/Copy-Directory.ps1
    kind: automation-function
    module: Catzc.Base.Files
    visibility: public
    relatives:
      page: docs/references/automation/catzc-base-files/Copy-Directory.ps1.md
      test: automation/Catzc.Base.Files/tests/Copy-Directory.Tests.ps1
    adrs:
      - ADR-PWSH-ENUM#3
  config:
    synopsis: Recursively copies the contents of a directory into a destination directory.
    description: |-
      A fast replacement for `Copy-Item -Recurse`, built on [System.IO]. The PowerShell file
      cmdlets carry heavy per-item provider overhead on Windows (~15x slower per file/dir here),
      which dominates when copying a tree of many small files; the raw .NET APIs avoid it.

      Mirrors the tree under -Path into -Destination — the equivalent of
      `Copy-Item (Join-Path $Path '*') $Destination -Recurse`. The destination is created if it
      does not exist, files are overwritten, and empty subdirectories are preserved.
    parameters:
      Path: The source directory whose contents are copied. Must exist.
      Destination: The target directory the contents are copied into (created if missing).
    examples:
      - Copy-Directory $fixtureTemplates $sandbox
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
