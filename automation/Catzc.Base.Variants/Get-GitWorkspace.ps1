<#
.SYNOPSIS
    Returns the repo's git workspace mode ('main-direct' or 'main-via-pr').
.DESCRIPTION
    The `git_workspace` repo-wide variant (configs/variants.yml), fixed for the importer session: how changes reach...
    [comment:1](/docs/references/automation/catzc-base-variants/Get-GitWorkspace.ps1.md#comment1)
.EXAMPLE
    Get-GitWorkspace   # -> 'main-direct'
#>
function Get-GitWorkspace {
    [CmdletBinding()]
    [OutputType([string])]
    param()

    "$(Get-Variant -Name git_workspace -Default 'main-direct')"
}
