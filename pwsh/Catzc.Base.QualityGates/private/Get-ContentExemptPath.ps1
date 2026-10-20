<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.QualityGates/private/Get-ContentExemptPath.ps1
    folder: private
    name: get-content-exempt-path
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
    test: pwsh/Catzc.Base.QualityGates/tests/Get-ContentExemptPath.Tests.ps1
    docs: "[Get-ContentExemptPath.ps1.md](docs/references/pwsh/catzc-base-qualitygates/private/Get-ContentExemptPath.ps1.md)"
    cites:
      - ADR-DSGN-TRACK-UNORDEREDTRACK
      - ADR-REPO-CONTRACT-CONTRACTASSET
      - ADR-REPO-ROOTCFG-FULLYMANAGED
---
#>

function Get-ContentExemptPath {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [Parameter(Mandatory)]
        [string] $RepositoryRoot,

        [Parameter(Mandatory)]
        [AllowEmptyCollection()]
        [string[]] $Path
    )

    $classNames = 'linguist-vendored', 'linguist-generated', 'catzc-fixture', 'catzc-contract', 'catzc-unordered'
    if ($Path.Count -eq 0) {
        return , [string[]] @()
    }
    $attributes = Get-GitAttributeValue -RepositoryRoot $RepositoryRoot -Path $Path -Attribute $classNames
    , [string[]] @($Path | Where-Object {
            $classes = $attributes[$_]
            $classes -and @($classNames | Where-Object { $classes[$_] -in 'set', 'true' }).Count -gt 0
        })
}
