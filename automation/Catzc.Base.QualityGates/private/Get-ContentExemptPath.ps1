<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/private/Get-ContentExemptPath.ps1
    kind: function
    module: Catzc.Base.QualityGates
    visibility: private
    adrs:
      - ADR-REPO-CONTRACT#6
      - ADR-REPO-ROOTCFG#1
---
#>

<#
.SYNOPSIS
    Lists which of the given paths the content tools leave as written.
.DESCRIPTION
    Exemption comes only from the gitattributes classes, never from a tool's own list; this names which classes count.
    [comment:1](/docs/references/automation/catzc-base-qualitygates/private/Get-ContentExemptPath.ps1.md#comment1)
.PARAMETER RepositoryRoot
    The repository root the paths are relative to.
.PARAMETER Path
    Repository-relative, '/'-separated paths.
.OUTPUTS
    [string[]] The given paths that are exempt, in the given order.
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

    $classNames = 'linguist-vendored', 'linguist-generated', 'catzc-fixture', 'catzc-contract', 'catzc-notes'
    if ($Path.Count -eq 0) {
        return , [string[]] @()
    }
    $attributes = Get-GitAttributeValue -RepositoryRoot $RepositoryRoot -Path $Path -Attribute $classNames
    , [string[]] @($Path | Where-Object {
            $classes = $attributes[$_]
            $classes -and @($classNames | Where-Object { $classes[$_] -in 'set', 'true' }).Count -gt 0
        })
}
