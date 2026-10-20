function Test-IdiomaticNames {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Reports.QualityGateResult])]
    param(
        [string] $OutputFolder,

        [switch] $PassThru
    )

    Assert-SourceTree

    $tracked = @(Get-GitTrackedPath '.')
    $issues = (Get-Config -Config languages).MisnamedPaths([string[]] $tracked)

    Write-QualityGateReport -Subject idiomatic-names -Title Test-IdiomaticNames -Issues ([string[]] @($issues)) `
        -Facts ([ordered]@{ Files = $tracked.Count }) -OutputFolder $OutputFolder -PassThru:$PassThru
}
