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
