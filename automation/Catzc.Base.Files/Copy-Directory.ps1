<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Files/Copy-Directory.ps1
    kind: public-function
    module: Catzc.Base.Files
    visibility: public
    adrs:
      - ADR-PWSH-ENUM#3
---
#>

<#
.SYNOPSIS
    Recursively copies the contents of a directory into a destination directory.
.DESCRIPTION
    The PowerShell file cmdlets cost about 15x more per item on Windows, which dominates a tree of many small files.
.PARAMETER Path
    The source directory whose contents are copied. Must exist.
.PARAMETER Destination
    The target directory the contents are copied into (created if missing).
.EXAMPLE
    Copy-Directory $fixtureTemplates $sandbox
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

    # Substring past the source prefix rebases a path; String.Replace would rewrite any later copy of that prefix too.
    # [comment:2](/docs/references/automation/catzc-base-files/Copy-Directory.ps1.md#comment2)
    # A named whole-tree walk ([ADR-PWSH-ENUM#3](/docs/adr/pwsh/bounded-enumeration.md#rule-adr-pwsh-enum3)): a copy
    # takes everything, so no name is pruned and no depth drops a file.
    foreach ($dir in Get-ChildPath $source -Directory -Depth 64 -Exclude @() -PruneVendor $false) {
        [System.IO.Directory]::CreateDirectory($target + $dir.Substring($sourceLen)) | Out-Null
    }
    foreach ($file in Get-ChildPath $source -File -Depth 64 -Exclude @() -PruneVendor $false) {
        [System.IO.File]::Copy($file, $target + $file.Substring($sourceLen), $true)
    }
}
