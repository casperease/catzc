<#
.SYNOPSIS
    Returns the managed-GUID registry entries — the named GUIDs the repository is allowed to carry.
.DESCRIPTION
    Thin accessor over Get-Config -Config guids (validated by Assert-GuidsConfig on load, session-cached).
    The returned map is a live view into the config cache — treat it as read-only. Each entry is
    name -> { guid, description [, sentence] }; `sentence` is present when the GUID was minted from a
    sentence with ConvertTo-Guid.
.OUTPUTS
    [System.Collections.IDictionary] entry-name -> entry (empty when the registry has no entries).
.EXAMPLE
    Get-ManagedGuids
#>
function Get-ManagedGuids {
    [CmdletBinding()]
    param()

    $config = Get-Config -Config guids
    if ($null -eq $config.guids) {
        return [ordered]@{}
    }
    $config.guids
}
