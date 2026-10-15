<#
.SYNOPSIS
    Answers whether a GUID is registered in the managed-GUID registry (configs/guids.yml).
.DESCRIPTION
    Matches by guid value, not text, so case never matters; it cannot disagree with Assert-ManagedGuid.
    [comment:1](/docs/references/automation/catzc-base-qualitygates/Test-ManagedGuid.ps1.md#comment1)
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
