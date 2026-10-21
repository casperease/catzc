<#
---
catzc:
  immutable:
    with_body_sha: "2eefb4d275a8"
  edges:
    test: pwsh/Catzc.Base.QualityGates/tests/Get-ScopeLookup.Tests.ps1
    docs: "[Get-ScopeLookup.ps1.md](docs/references/pwsh/catzc-base-quality-gates/private/Get-ScopeLookup.ps1.md)"
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
        $full = [System.IO.Path]::GetFullPath($item, (Get-Location).ProviderPath)
        $relative = [System.IO.Path]::GetRelativePath($root, $full) -replace '\\', '/'
        Assert-False ($relative -eq '..' -or $relative.StartsWith('../')) -ErrorText "${Command}: -Path '$item' lies outside the repository '$root'."
        # A path the index lists but the working tree has lost, a deletion not yet staged, stays in scope; the reader skips it.
        if (-not (Test-Path -LiteralPath $full)) {
            Assert-True (@(Get-GitTrackedPath $relative).Count -gt 0) -ErrorText "${Command}: -Path '$item' does not exist and is not tracked."
        }
        $relative
    }
    , [string[]] @($lookup)
}
