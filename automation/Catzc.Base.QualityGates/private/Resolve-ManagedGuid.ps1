<#
.SYNOPSIS
    Resolves a GUID to its managed-registry entry, or $null when it is unregistered.
.DESCRIPTION
    The one comparison source behind Test-ManagedGuid and Assert-ManagedGuid — both route through this lookup, so the...
    [comment:1](/docs/references/automation/catzc-base-qualitygates/private/Resolve-ManagedGuid.ps1.md#comment1)
.OUTPUTS
    [System.Collections.Specialized.OrderedDictionary] @{ name; guid; description } for a registered GUID;
    $null otherwise.
#>
function Resolve-ManagedGuid {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [guid] $Guid
    )

    $entries = Get-ManagedGuids
    foreach ($name in @($entries.Keys)) {
        $entry = $entries[$name]
        if ([guid]"$($entry.guid)" -eq $Guid) {
            return [ordered]@{
                name        = "$name"
                guid        = "$($entry.guid)"
                description = "$($entry.description)"
            }
        }
    }
    $null
}
