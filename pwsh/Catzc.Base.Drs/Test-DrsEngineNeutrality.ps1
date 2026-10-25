<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-drs/Test-DrsEngineNeutrality.ps1.md"
  warning: "Generated Header"
---
#>

function Test-DrsEngineNeutrality {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Reports.QualityGateResult])]
    param(
        [string] $OutputFolder,

        [switch] $PassThru
    )

    $adrs = Get-Config -Config drs
    $settings = (Get-Config -Config drs-checks).engine_neutrality
    $index = Get-DrsFileIndex @($adrs.RuleSets) -DrsRoot (Resolve-RepoPath $adrs.Root)
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
            $issues.Add("drs-checks.yml: engine_neutrality domain '$domainName' is not a domain of drs.yml")
            continue
        }

        foreach ($ruleSet in $domain.RuleSets) {
            if (-not $index.FileOf.ContainsKey($ruleSet.External)) {
                continue
            }
            $ruleSetCount++
            $relative = $index.FileOf[$ruleSet.External]
            foreach ($summaryLine in (Get-DrsRuleSummaryLines ([System.IO.Path]::Combine($index.Root, $relative)))) {
                $lineCount++
                foreach ($token in $settings.tokens) {
                    $found = $token.Find($summaryLine.Text)
                    if ($found.Count -gt 0) {
                        $issues.Add("$($adrs.Root)/${relative}:$($summaryLine.Line): $($summaryLine.Rule): $($token.name) — $(($found | ForEach-Object { "'$_'" }) -join ', ')")
                    }
                }
            }
        }
    }

    # Report mode still writes and prints the report; only the throw is withheld.
    $reportOnly = $settings.mode -eq [Catzc.Base.Reports.CheckMode]::Report
    $result = Write-QualityGateReport -Subject 'drs-engine-neutrality' -Title 'Test-DrsEngineNeutrality' -Issues $issues `
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
