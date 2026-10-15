<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/Get-ManagedGuids.ps1
    kind: function
    module: Catzc.Base.QualityGates
    visibility: public
    adrs: []
---
#>

<#
.SYNOPSIS
    Returns the managed-GUID registry entries — the named GUIDs the repository is allowed to carry.
.DESCRIPTION
    The returned map is read-only, and an entry's sentence is set only when the GUID was minted with ConvertTo-Guid.
.OUTPUTS
    [System.Collections.Specialized.OrderedDictionary] entry-name -> entry (empty when the registry has no
    entries).
.EXAMPLE
    Get-ManagedGuids
#>
function Get-ManagedGuids {
    [CmdletBinding()]
    param()

    (Get-Config -Config guids).guids
}
