<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.QualityGates/private/Get-ScopeLookup.ps1
    folder: private
    name: get-scope-lookup
    filetype: ps1
    role: function
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    docs: "[Get-ScopeLookup.ps1.md](docs/references/pwsh/catzc-base-qualitygates/private/Get-ScopeLookup.ps1.md)"
---
#>

function Get-ScopeLookup {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [Parameter(Mandatory)]
        [string] $RepositoryRoot,

        [string[]] $Path,

        [Parameter(Mandatory)]
        [string] $Command
    )

    $root = [System.IO.Path]::GetFullPath($RepositoryRoot)
    if (-not $Path) {
        return , [string[]] @('.')
    }
    $lookup = foreach ($item in $Path) {
        $full = [System.IO.Path]::GetFullPath((Resolve-Path -LiteralPath $item).Path)
        $relative = [System.IO.Path]::GetRelativePath($root, $full) -replace '\\', '/'
        Assert-False ($relative -eq '..' -or $relative.StartsWith('../')) -ErrorText "${Command}: -Path '$item' lies outside the repository '$root'."
        $relative
    }
    , [string[]] @($lookup)
}
