<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Variants/Get-GitWorkspace.ps1
    kind: public-function
    module: Catzc.Base.Variants
    visibility: public
    adrs: []
---
#>

<#
.SYNOPSIS
    Returns the repo's git workspace mode ('main-direct' or 'main-via-pr').
.DESCRIPTION
    In main-via-pr mode the one forbidden act is a direct commit while standing on main; branches are free.
.EXAMPLE
    Get-GitWorkspace   # -> 'main-direct'
#>
function Get-GitWorkspace {
    [CmdletBinding()]
    [OutputType([string])]
    param()

    "$(Get-Variant -Name git_workspace -Default 'main-direct')"
}
