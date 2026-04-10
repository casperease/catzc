<#
.SYNOPSIS
    Reads a single repo-wide variant from configs/variants.yml, or a default when the key is absent.
.DESCRIPTION
    The one place variants.yml is read. Variants are fixed for the importer session (Get-Config caches the
    parsed config per session; re-run the importer to pick up an edit — see docs/adr/automation/caching.md).
    The typed primitives (Get-AdoNaming, Test-HaveCustomers, …) are thin wrappers over this reader so the
    growing variant dictionary has a single access point. Private — callers use the named primitives.
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
