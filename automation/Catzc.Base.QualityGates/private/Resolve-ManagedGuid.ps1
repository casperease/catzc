<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/private/Resolve-ManagedGuid.ps1
    kind: automation-function
    module: Catzc.Base.QualityGates
    visibility: private
  config:
    synopsis: Resolves a GUID to its managed-registry entry, or $null when it is unregistered.
    description: |-
      The one comparison source behind Test-ManagedGuid and Assert-ManagedGuid — both route through this
      lookup, so the bool and the throw can never drift. Comparison is by [guid] value, so any input casing
      matches the canonical lowercase form the registry stores.
    parameters:
      Guid: The GUID to look up in the managed registry; its casing does not matter.
    outputs: |-
      [System.Collections.Specialized.OrderedDictionary] @{ name; guid; description } for a registered GUID;
      $null otherwise.
---
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
