<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Variants/Get-GitWorkspace.ps1
    kind: function
    module: Catzc.Base.Variants
    visibility: public
---
#>

<#
.SYNOPSIS
    Returns the repo's git workspace mode ('main-direct' or 'main-via-pr').
.DESCRIPTION
    In main-via-pr mode the one forbidden act is a direct commit while standing on main; branches are free.
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
