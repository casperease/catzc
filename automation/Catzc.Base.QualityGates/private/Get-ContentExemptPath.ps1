<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.QualityGates/private/Get-ContentExemptPath.ps1
    folder: private
    name: get-content-exempt-path
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    test: automation/Catzc.Base.QualityGates/tests/Get-ContentExemptPath.Tests.ps1
    cites:
      - ADR-DSGN-TRACK#17
      - ADR-REPO-CONTRACT#6
      - ADR-REPO-ROOTCFG#1
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
