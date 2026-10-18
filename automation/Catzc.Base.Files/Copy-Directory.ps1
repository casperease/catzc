<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.Files/Copy-Directory.ps1
    name: copy-directory
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Files
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    page: docs/references/automation/catzc-base-files/Copy-Directory.ps1.md
    test: automation/Catzc.Base.Files/tests/Copy-Directory.Tests.ps1
    cites:
      - ADR-PWSH-ENUM#3
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
