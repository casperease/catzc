<#
.SYNOPSIS
    Quality gate: the ADR registry (adrs.yml) and the ADR rule files under docs/adr/ agree.
.DESCRIPTION
    A quality gate ([ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35)) over the ADR
    registry (Get-Config -Config adrs, an AdrsConfig) and the ADR files it registers. An ADR rule file is a
    docs/adr/**/*.md that declares a `## Rules: <code>` registry; the other files there (the generated index and
    glossary, each domain's dora-explains.md, a folder's index.md or README.md) carry none and are out of scope.
    It collects an issue when:

      - a rule set has no file docs/adr/<domain>/**/<slug>.md, or more than one;
      - a rule set's file does not head its registry `## Rules: <External>` with the registered external code;
      - a rule file is registered by no rule set (its `<domain folder>/<slug>` is not in adrs.yml).

    The registry's own invariants (unique external codes, declared and acyclic domain links) are AdrsConfig
    construction rules, not this gate's.
.PARAMETER OutputFolder
    The report base folder. Defaults to out/test-adr-registry/ (Write-QualityGateReport).
.PARAMETER PassThru
    Return the result ({ Subject; IssueCount; Issues; ReportPath; RuleSets; Files }) instead of throwing on issues.
.OUTPUTS
    [pscustomobject] With -PassThru only.
.EXAMPLE
    Test-AdrRegistry
#>
function Test-AdrRegistry {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [string] $OutputFolder,

        [switch] $PassThru
    )

    $ruleSets = @((Get-Config -Config adrs).RuleSets)
    $adrRoot = Resolve-RepoPath 'docs/adr'
    $issues = [System.Collections.Generic.List[string]]::new()

    # Index every ADR .md by "<domain folder>/<slug>" so a slug shared across domains (one in automation/, one in
    # research/) stays distinct, and a slug repeated within one domain's subfolders is caught as a duplicate.
    $filesByKey = @{}
    $rulesHeadingByPath = @{}
    $fileCount = 0
    foreach ($file in [System.IO.Directory]::EnumerateFiles($adrRoot, '*.md', [System.IO.SearchOption]::AllDirectories)) {
        $fileCount++
        $relative = $file.Substring($adrRoot.Length).TrimStart('\', '/').Replace('\', '/')
        $segments = $relative.Split('/')
        $domainFolder = if ($segments.Count -gt 1) {
            $segments[0]
        }
        else {
            ''
        }
        $key = "$domainFolder/$([System.IO.Path]::GetFileNameWithoutExtension($file))"
        if (-not $filesByKey.ContainsKey($key)) {
            $filesByKey[$key] = [System.Collections.Generic.List[string]]::new()
        }
        $filesByKey[$key].Add($relative)
        $heading = [regex]::Match([System.IO.File]::ReadAllText($file), '(?m)^## Rules: (?<code>\S+)\s*$')
        if ($heading.Success) {
            $rulesHeadingByPath[$relative] = $heading.Groups['code'].Value
        }
    }

    $registeredKeys = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::Ordinal)
    foreach ($ruleSet in $ruleSets) {
        $key = "$($ruleSet.Domain)/$($ruleSet.Slug)"
        [void]$registeredKeys.Add($key)
        $files = @(if ($filesByKey.ContainsKey($key)) {
                $filesByKey[$key]
            })
        if ($files.Count -eq 0) {
            $issues.Add("$($ruleSet.External): no ADR file docs/adr/$($ruleSet.Domain)/**/$($ruleSet.Slug).md")
            continue
        }
        if ($files.Count -gt 1) {
            $issues.Add("$($ruleSet.External): $($files.Count) ADR files named $($ruleSet.Slug).md under docs/adr/$($ruleSet.Domain)/ — $(($files | ForEach-Object { "docs/adr/$_" }) -join ', ')")
            continue
        }
        if ($rulesHeadingByPath[$files[0]] -cne $ruleSet.External) {
            $issues.Add("docs/adr/$($files[0]): must head its rule registry '## Rules: $($ruleSet.External)' (the adrs.yml external code)")
        }
    }

    foreach ($relative in @($rulesHeadingByPath.Keys | Sort-Object)) {
        $segments = $relative.Split('/')
        $domainFolder = if ($segments.Count -gt 1) {
            $segments[0]
        }
        else {
            ''
        }
        $key = "$domainFolder/$([System.IO.Path]::GetFileNameWithoutExtension($relative))"
        if (-not $registeredKeys.Contains($key)) {
            $issues.Add("docs/adr/${relative}: declares '## Rules: $($rulesHeadingByPath[$relative])' but no adrs.yml rule set registers it")
        }
    }

    Write-QualityGateReport -Subject 'adr-registry' -Title 'Test-AdrRegistry' -Issues $issues `
        -Facts ([ordered]@{ RuleSets = $ruleSets.Count; Files = $fileCount }) -OutputFolder $OutputFolder -PassThru:$PassThru
}
