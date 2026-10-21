<#
---
catzc:
  immutable:
    with_body_sha: "6f87a13cfc96"
  edges:
    test: pwsh/Catzc.Base.QualityGates/tests/Get-ContentExemptPath.Tests.ps1
    docs: "[Get-ContentExemptPath.ps1.md](../../../docs/references/pwsh/catzc-base-quality-gates/private/Get-ContentExemptPath.ps1.md)"
    cites:
      - ADR-REPO-CONTRACT-CONTRACTASSET
      - ADR-REPO-ROOTCFG-FULLYMANAGED
      - DDR-TRACK-UNORDEREDTRACK
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
