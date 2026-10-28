function Get-AnalyzerDrsCoverage {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param()

    $config = Get-Config -Config analyzer-drs-map
    foreach ($analyzer in $config.analyzers.Keys) {
        foreach ($recordId in $config.analyzers[$analyzer]) {
            [pscustomobject]@{
                RecordId = $recordId
                Enforcer = $analyzer
                Kind     = 'pssa-rule'
            }
        }
    }
}
