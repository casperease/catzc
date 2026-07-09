<#
.SYNOPSIS
    Renders the ADR-rule enforcement coverage report (rule-coverage.md + rule-coverage.csv) from a run's rows.
.DESCRIPTION
    Builds the (ADR rule -> enforcers) map and writes it as a report artifact. An enforcer is one of two kinds,
    both run in the same Test-Automation invocation: a 'pester-test' (a test tagged with the rule's citation,
    read from each row's Rules column) or a 'pssa-rule' (a PSScriptAnalyzer rule mapped to the rule, from
    Get-AnalyzerAdrCoverage). Counting the analyzer rules is what makes the "uncovered" list honest — a rule
    like ADR-AUTO-NOPWD reads as covered because its custom analyzer fails the build on every run.

    A pure function of its inputs (no config or ADR reads of its own), so the caller passes the rule universe
    and the analyzer coverage in. Report-only: it never throws on an uncovered rule — many rules are enforced
    structurally or by review, so absence of a mechanical enforcer is information, not a defect. The 'by test'
    figures reflect the tests in THIS run's scope (a -Modules/-Level filter narrows the rows).
.PARAMETER Rows
    The aggregated per-test rows (ConvertTo-TestAutomationRowSet), each carrying ExpandedPath and the
    ';'-joined Rules citations.
.PARAMETER AnalyzerCoverage
    The (AdrId, Enforcer, Kind='pssa-rule') rows from Get-AnalyzerAdrCoverage. AdrId is '#' citation form.
.PARAMETER AllRuleIds
    Every declared ADR rule id in '#' citation form (Get-CatsAdrRuleIds, ':'->'#') — the coverage universe.
.PARAMETER OutputFolder
    The run directory the two files are written into (created if missing).
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

    # Enforcers per rule id, split by kind. Sets so a rule cited by many tests, or an analyzer listed twice,
    # counts each enforcer once.
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
    $allIds = [System.Collections.Generic.SortedSet[string]]::new([string[]] $AllRuleIds, [System.StringComparer]::Ordinal)
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
