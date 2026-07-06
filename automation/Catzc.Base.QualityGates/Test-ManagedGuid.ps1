<#
.SYNOPSIS
    Answers whether a GUID is registered in the managed-GUID registry (configs/guids.yml).
.DESCRIPTION
    The boolean counterpart of Assert-ManagedGuid; both share one lookup (Resolve-ManagedGuid), so they
    can never disagree. Comparison is case-insensitive by [guid] value.
.PARAMETER Guid
    The GUID to check.
.OUTPUTS
    [bool] $true when the GUID is registered; $false otherwise.
.EXAMPLE
    Test-ManagedGuid '499b84ac-1321-427f-aa17-267ca6975798'
#>
function Test-ManagedGuid {
    [CmdletBinding()]
    [OutputType([bool])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [guid] $Guid
    )

    $found = Resolve-ManagedGuid $Guid
    $null -ne $found
}
