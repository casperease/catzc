<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Docs/Test-AdrEngineNeutrality.ps1
    kind: gate-function
    module: Catzc.Base.Docs
    visibility: public
    relatives:
      test: automation/Catzc.Base.Docs/tests/Test-AdrEngineNeutrality.Tests.ps1
    adrs:
      - ADR-AUTO-ENGINE#1
      - ADR-AUTO-TEST#35
  config:
    synopsis: 'Quality gate: the rule summaries of the configured ADR domains carry no engine-specific syntax.'
    description: |-
      A quality gate ([ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35)) over the rule summaries (the
      `### Rule <code>:<n>` entries, Get-AdrRuleSummaryLines) of every rule set in the domains listed under engine_neutrality.domains in
      adr-checks.yml. The engine-agnostic rules hold for every execution engine
      ([ADR-AUTO-ENGINE#1](/docs/adr/automation/execution-engines.md#rule-adr-auto-engine1)), so their summaries state a rule, never one
      engine's syntax: each token under engine_neutrality.tokens is a regular expression for such syntax, and every match is a finding,
      reported with its file and line. Naming a catzc command is allowed, so the tokens list engine built-ins only.

      A domain in that list that adrs.yml does not declare is a finding too. A rule set with no file, or several, is Test-AdrRegistry's
      finding and is skipped.

      The check's mode is engine_neutrality.mode (Catzc.Base.Docs.AdrChecksConfig): in gate mode the gate throws once listing every
      finding; in report mode it prints the findings and their count, writes the same report, and never throws.
    parameters:
      OutputFolder: The report base folder. Defaults to out/test-adr-engine-neutrality/ (Write-QualityGateReport).
      PassThru: Return the result ({ Subject; IssueCount; Issues; ReportPath; Mode; Domains; RuleSets; Lines }) instead of throwing on issues.
    outputs: '[pscustomobject] With -PassThru only.'
    examples:
      - Test-AdrEngineNeutrality
      - (Test-AdrEngineNeutrality -PassThru).Issues
---
#>

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
