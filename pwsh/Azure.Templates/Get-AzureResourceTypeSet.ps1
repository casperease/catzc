function Get-AzureResourceTypeSet {
    param()

    # A copy per call, so a caller that changes an entry never changes the cached config.
    $types = (Get-Config -Config resource-types).types
    $set = [ordered]@{}
    foreach ($abbreviation in $types.Keys) {
        $entry = @{}
        foreach ($key in $types[$abbreviation].Keys) {
            $entry[$key] = $types[$abbreviation][$key]
        }
        $set[$abbreviation] = $entry
    }
    $set
}
