<#
.SYNOPSIS
    Returns the managed-GUID registry entries — the named GUIDs the repository is allowed to carry.
.DESCRIPTION
    Thin accessor over Get-Config -Config guids (mapped and validated by the GuidsConfig type on load, session-cached).
    [comment:1](/docs/references/automation/catzc-base-qualitygates/Get-ManagedGuids.ps1.md#comment1)
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
