function Get-AzureNamePatternSet {
    param()

    # A copy per call, so a caller that changes an entry never changes the cached config.
    $patterns = (Get-Config -Config resource-types).patterns
    $set = [ordered]@{}
    foreach ($name in $patterns.Keys) {
        $entry = @{}
        foreach ($key in $patterns[$name].Keys) {
            $entry[$key] = $patterns[$name][$key]
        }
        $set[$name] = $entry
    }
    $set
}
