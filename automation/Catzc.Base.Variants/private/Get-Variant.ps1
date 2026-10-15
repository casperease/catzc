<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Variants/private/Get-Variant.ps1
    kind: private-function
    module: Catzc.Base.Variants
    visibility: private
    adrs:
      - ADR-AUTO-CACHE
---
#>

<#
.SYNOPSIS
    Reads a single repo-wide variant from configs/variants.yml, or a default when the key is absent.
.DESCRIPTION
    Variants are fixed for the importer session (Get-Config caches them), so re-run the importer to pick up an edit.
.PARAMETER Name
    The variant key (a top-level key of variants.yml, e.g. 'ado_naming').
.PARAMETER Default
    The value to return when the key is absent from the file.
.EXAMPLE
    Get-Variant -Name ado_naming -Default 'standard'
#>
function Get-Variant {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Name,

        [Parameter(Position = 1)]
        [AllowNull()]
        $Default
    )

    $variants = Get-Config -Config variants
    if ($variants.Contains($Name)) {
        return $variants[$Name]
    }
    $Default
}
