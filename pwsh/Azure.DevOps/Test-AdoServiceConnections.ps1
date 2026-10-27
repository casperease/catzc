function Test-AdoServiceConnections {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Reports.QualityGateResult])]
    param(
        [string] $Project = (Get-Config -Config ado)['project'],

        [string] $Organization = (Get-Config -Config ado)['organization'],

        [string] $OutputFolder,

        [switch] $PassThru
    )

    Assert-NotNullOrWhitespace $Project -ErrorText 'Project is required. Set -Project or configure ado.yml.'
    Assert-NotNullOrWhitespace $Organization -ErrorText 'Organization is required. Set -Organization or configure ado.yml.'
    $Organization = $Organization.TrimEnd('/')
    $scheme = [Catzc.Azure.DevOps.ServiceConnectionsConfig]::Scheme
    $configured = (Get-Config -Config service-connections).connections

    # Every Azure connection of the project, configured or not: a stored secret on any of them is a finding.
    $issues = [System.Collections.Generic.List[string]]::new()
    $live = @(Invoke-AdoRestMethod -Uri "$Organization/$Project/_apis/serviceendpoint/endpoints?type=azurerm&api-version=7.1" |
            Where-Object { $null -ne $_ })
    $seen = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::Ordinal)
    foreach ($endpoint in $live) {
        $name = "$($endpoint.name)"
        [void]$seen.Add($name)
        if ("$($endpoint.authorization.scheme)" -ne $scheme) {
            $issues.Add("${name}: authenticates with '$($endpoint.authorization.scheme)', a stored credential — run Sync-AdoServiceConnections to convert it to $scheme")
        }
        if (-not $configured.ContainsKey($name)) {
            $issues.Add("${name}: not in service-connections.yml — declare it there, or delete it in Azure DevOps")
        }
    }
    foreach ($name in $configured.Keys) {
        if (-not $seen.Contains($name)) {
            $issues.Add("${name}: in service-connections.yml but not in $Organization/$Project — run Sync-AdoServiceConnections")
        }
    }

    Write-QualityGateReport -Subject 'service-connections' -Title 'Test-AdoServiceConnections' -Issues $issues `
        -Facts ([ordered]@{ Configured = $configured.Count; Live = $live.Count }) -OutputFolder $OutputFolder -PassThru:$PassThru
}
