<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/private/Resolve-ManagedGuid.ps1
    kind: function
    module: Catzc.Base.QualityGates
    visibility: private
    adrs: []
---
#>

<#
.SYNOPSIS
    Resolves a GUID to its managed-registry entry, or $null when it is unregistered.
.DESCRIPTION
    Both the bool and the throwing check use this lookup, so they cannot drift; any input casing matches.
    [comment:1](/docs/references/automation/catzc-base-qualitygates/private/Resolve-ManagedGuid.ps1.md#comment1)
.PARAMETER Guid
    The GUID to look up in the managed registry; its casing does not matter.
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
