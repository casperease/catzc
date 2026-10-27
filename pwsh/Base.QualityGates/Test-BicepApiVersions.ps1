function Test-BicepApiVersions {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Reports.QualityGateResult])]
    param(
        [Catzc.Base.QualityGates.BicepApiVersionsConfig] $Config = (Get-Config -Config bicep-api-versions),

        [datetime] $Today = [datetime]::Today,

        [string] $OutputFolder,

        [switch] $PassThru
    )

    $issues = [System.Collections.Generic.List[string]]::new()
    $reference = [regex]::new("'(?<type>[A-Za-z0-9.]+/[A-Za-z0-9./]+)@(?<version>[0-9]{4}-[0-9]{2}-[0-9]{2}(-preview)?)'")

    # The modules sit at their folder's root, a template one folder down (templates/<name>/main.bicep).
    $files = @(@(foreach ($folder in $Config.folders) {
                Get-ChildPath -Path (Join-Path (Get-RepositoryRoot) $folder) -Depth 2 -Filter '*.bicep' -File
            }) | Sort-Object -Unique)
    $references = 0
    foreach ($file in $files) {
        $relative = ConvertTo-RepoRelativePath $file
        $number = 0
        foreach ($line in [System.IO.File]::ReadAllLines($file)) {
            $number++
            foreach ($match in $reference.Matches($line)) {
                $references++
                $type = $match.Groups['type'].Value
                $version = $match.Groups['version'].Value
                $finding = $Config.Verdict($type, $version, $Today)
                if ($finding) {
                    $issues.Add("${relative}:$number ${type}@${version}: $finding — move to a current stable version, or pin it in bicep-api-versions.yml allowed")
                }
            }
        }
    }

    Write-QualityGateReport -Subject 'bicep-api-versions' -Title 'Test-BicepApiVersions' -Issues $issues `
        -Facts ([ordered]@{ Files = $files.Count; References = $references; MaxAgeMonths = $Config.max_age_months }) `
        -OutputFolder $OutputFolder -PassThru:$PassThru
}
