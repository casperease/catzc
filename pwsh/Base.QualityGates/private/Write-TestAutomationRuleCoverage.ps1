<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-quality-gates/private/Write-TestAutomationRuleCoverage.ps1.md"
  header: "generated"
---
#>

function Write-TestAutomationRuleCoverage {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [AllowEmptyCollection()]
        [object[]] $Rows,

        [Parameter(Mandatory)]
        [AllowEmptyCollection()]
        [object[]] $AnalyzerCoverage,

        [Parameter(Mandatory)]
        [AllowEmptyCollection()]
        [string[]] $AllRuleIds,

        [Parameter(Mandatory)]
        [string] $OutputFolder
    )

    if (-not (Test-Path $OutputFolder -PathType Container)) {
        New-Item -ItemType Directory -Path $OutputFolder -Force | Out-Null
    }

    # Sets, so each enforcer counts once however often it cites a rule.
    $testEnforcers = @{}
    $analyzerEnforcers = @{}

    foreach ($row in $Rows) {
        if (-not $row.Rules) {
            continue
        }
        foreach ($id in ($row.Rules -split ';')) {
            if (-not $id) {
                continue
            }
            if (-not $testEnforcers.ContainsKey($id)) {
                $testEnforcers[$id] = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::Ordinal)
            }
            [void]$testEnforcers[$id].Add($row.ExpandedPath)
        }
    }
    foreach ($analyzerRow in $AnalyzerCoverage) {
        $id = $analyzerRow.AdrId
        if (-not $analyzerEnforcers.ContainsKey($id)) {
            $analyzerEnforcers[$id] = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::Ordinal)
        }
        [void]$analyzerEnforcers[$id].Add($analyzerRow.Enforcer)
    }

    # The coverage universe: every declared rule, plus any id a test or analyzer references defensively.
    $allIds = [System.Collections.Generic.SortedSet[string]]::new([string[]] $AllRuleIds,
        [System.StringComparer]::Ordinal)
    foreach ($id in $testEnforcers.Keys) {
        [void]$allIds.Add($id)
    }
    foreach ($id in $analyzerEnforcers.Keys) {
        [void]$allIds.Add($id)
    }

    $uncovered = [System.Collections.Generic.List[string]]::new()
    $coveredByTest = 0
    $coveredByAnalyzer = 0
    $csvRows = [System.Collections.Generic.List[object]]::new()
    foreach ($id in $allIds) {
        $hasTest = $testEnforcers.ContainsKey($id)
        $hasAnalyzer = $analyzerEnforcers.ContainsKey($id)
        if ($hasTest) {
            $coveredByTest++
            foreach ($testPath in ($testEnforcers[$id] | Sort-Object)) {
                $csvRows.Add([pscustomobject]@{ AdrId = $id; Kind = 'pester-test'; Enforcer = $testPath })
            }
        }
        if ($hasAnalyzer) {
            $coveredByAnalyzer++
            foreach ($analyzerName in ($analyzerEnforcers[$id] | Sort-Object)) {
                $csvRows.Add([pscustomobject]@{ AdrId = $id; Kind = 'pssa-rule'; Enforcer = $analyzerName })
            }
        }
        if (-not ($hasTest -or $hasAnalyzer)) {
            $uncovered.Add($id)
            $csvRows.Add([pscustomobject]@{ AdrId = $id; Kind = 'uncovered'; Enforcer = '' })
        }
    }

    $csvRows | Export-Csv -Path (Join-Path $OutputFolder 'rule-coverage.csv') -NoTypeInformation -Encoding utf8

    $total = $allIds.Count
    $coveredCount = $total - $uncovered.Count

    $stringBuilder = [System.Text.StringBuilder]::new()
    [void]$stringBuilder.AppendLine('# ADR rule enforcement coverage')
    [void]$stringBuilder.AppendLine('')
    [void]$stringBuilder.AppendLine("- Rules total: $total")
    [void]$stringBuilder.AppendLine("- Covered: $coveredCount (by a tagged test: $coveredByTest, by an analyzer rule: $coveredByAnalyzer — a rule may be both)")
    [void]$stringBuilder.AppendLine("- Uncovered: $($uncovered.Count)")
    [void]$stringBuilder.AppendLine('- Report only — a rule with no mechanical enforcer may still be enforced structurally or by review.')
    [void]$stringBuilder.AppendLine("- 'By a tagged test' reflects the tests in this run's scope (a -Modules/-Level filter narrows it).")
    [void]$stringBuilder.AppendLine('')

    [void]$stringBuilder.AppendLine("## Uncovered rules ($($uncovered.Count))")
    [void]$stringBuilder.AppendLine('')
    if ($uncovered.Count -eq 0) {
        [void]$stringBuilder.AppendLine('_None._')
    }
    else {
        foreach ($id in $uncovered) {
            [void]$stringBuilder.AppendLine("- $id")
        }
    }
    [void]$stringBuilder.AppendLine('')

    [void]$stringBuilder.AppendLine("## Covered rules ($coveredCount)")
    [void]$stringBuilder.AppendLine('')
    [void]$stringBuilder.AppendLine('| Rule | Tests | Analyzer rules |')
    [void]$stringBuilder.AppendLine('| ---- | ----- | -------------- |')
    foreach ($id in $allIds) {
        $testCount = if ($testEnforcers.ContainsKey($id)) {
            $testEnforcers[$id].Count
        }
        else {
            0
        }
        $analyzerNames = if ($analyzerEnforcers.ContainsKey($id)) {
            (($analyzerEnforcers[$id] | Sort-Object) -join ', ')
        }
        else {
            ''
        }
        if ($testCount -gt 0 -or $analyzerNames) {
            [void]$stringBuilder.AppendLine("| $id | $testCount | $analyzerNames |")
        }
    }
    [void]$stringBuilder.AppendLine('')

    [System.IO.File]::WriteAllText((Join-Path $OutputFolder 'rule-coverage.md'), $stringBuilder.ToString())
}
