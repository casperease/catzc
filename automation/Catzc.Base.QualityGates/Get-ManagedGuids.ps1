<#
.SYNOPSIS
    Returns the managed-GUID registry entries — the named GUIDs the repository is allowed to carry.
.DESCRIPTION
    Thin accessor over Get-Config -Config guids (mapped and validated by the GuidsConfig type on load,
    session-cached). The returned map is read-only. Each entry is name -> ManagedGuidEntry
    { guid, description [, sentence] }; `sentence` is set when the GUID was minted from a sentence with
    ConvertTo-Guid.
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
