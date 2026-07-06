<#
.SYNOPSIS
    Asserts a GUID is registered in the managed-GUID registry (configs/guids.yml); throws when it is not.
.DESCRIPTION
    The throwing counterpart of Test-ManagedGuid; both share one lookup (Resolve-ManagedGuid), so they can
    never disagree. Comparison is case-insensitive by [guid] value. Succeeds silently — the absence of an
    error is the output.
.PARAMETER Guid
    The GUID to assert.
.EXAMPLE
    Assert-ManagedGuid '499b84ac-1321-427f-aa17-267ca6975798'
#>
function Assert-ManagedGuid {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [guid] $Guid
    )

    $found = Resolve-ManagedGuid $Guid
    if ($null -eq $found) {
        throw "Guid '$Guid' is not registered in the managed-GUID registry (automation/Catzc.Base.QualityGates/configs/guids.yml). Register it — mint a readable placeholder with ConvertTo-Guid — or remove it."
    }
}
