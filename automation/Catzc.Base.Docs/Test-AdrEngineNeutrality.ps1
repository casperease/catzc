function Test-AdrEngineNeutrality {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [string] $OutputFolder,

        [switch] $PassThru
    )

    $adrs = Get-Config -Config adrs
    $settings = (Get-Config -Config adr-checks).engine_neutrality
    $index = Get-AdrFileIndex @($adrs.RuleSets) -AdrRoot (Resolve-RepoPath 'docs/adr')
    $issues = [System.Collections.Generic.List[string]]::new()

    $ruleSetCount = 0
    $lineCount = 0
    foreach ($domainName in $settings.domains) {
        $domain = $null
        foreach ($candidate in $adrs.Domains) {
            if ($candidate.Name -ceq $domainName) {
                $domain = $candidate
            }
        }
        if ($null -eq $domain) {
            $issues.Add("adr-checks.yml: engine_neutrality domain '$domainName' is not a domain of adrs.yml")
            continue
        }

        foreach ($ruleSet in $domain.RuleSets) {
            if (-not $index.FileOf.ContainsKey($ruleSet.External)) {
                continue
            }
            $ruleSetCount++
            $relative = $index.FileOf[$ruleSet.External]
            foreach ($summaryLine in (Get-AdrRuleSummaryLines ([System.IO.Path]::Combine($index.Root, $relative)))) {
                $lineCount++
                foreach ($token in $settings.tokens) {
                    $found = $token.Find($summaryLine.Text)
                    if ($found.Count -gt 0) {
                        $issues.Add("docs/adr/${relative}:$($summaryLine.Line): $($summaryLine.Rule): $($token.name) — $(($found | ForEach-Object { "'$_'" }) -join ', ')")
                    }
                }
            }
        }
    }

    # Report mode still writes and prints the report; only the throw is withheld.
    $reportOnly = $settings.mode -eq [Catzc.Base.Docs.CheckMode]::Report
    $result = Write-QualityGateReport -Subject 'adr-engine-neutrality' -Title 'Test-AdrEngineNeutrality' -Issues $issues `
        -Facts ([ordered]@{
            Mode     = $settings.mode.ToString().ToLowerInvariant()
            Domains  = $settings.domains -join ', '
            RuleSets = $ruleSetCount
            Lines    = $lineCount
        }) -OutputFolder $OutputFolder -PassThru:($PassThru -or $reportOnly)
    if ($PassThru) {
        $result
    }
}
