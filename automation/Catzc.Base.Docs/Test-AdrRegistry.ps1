<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Docs/Test-AdrRegistry.ps1
    kind: function
    module: Catzc.Base.Docs
    visibility: public
    adrs:
      - ADR-AUTO-TEST#35
      - ADR-PRIN-CONFIG#1
---
#>

<#
.SYNOPSIS
    Quality gate: the ADR registry (adrs.yml) and the ADR rule files under docs/adr/ agree.
.DESCRIPTION
    Unique codes and acyclic links between domains are AdrsConfig construction rules, so this gate does not recheck them.
    [ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35)
    [comment:1](/docs/references/automation/catzc-base-docs/Test-AdrRegistry.ps1.md#comment1)
.PARAMETER OutputFolder
    A report-mode check writes under this folder only when it is given, else under its own default folder.
    [comment:2](/docs/references/automation/catzc-base-docs/Test-AdrRegistry.ps1.md#comment2)
.PARAMETER PassThru
    CitationGraph and DoraCoverage list each check's findings in either mode, so a report-mode check can be read.
    [comment:3](/docs/references/automation/catzc-base-docs/Test-AdrRegistry.ps1.md#comment3)
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

    $adrs = Get-Config -Config adrs
    $checks = Get-Config -Config adr-checks
    $ruleSets = @($adrs.RuleSets)
    $index = Get-AdrFileIndex $ruleSets -AdrRoot (Resolve-RepoPath 'docs/adr')
    $issues = [System.Collections.Generic.List[string]]::new()

    $rulesHeadingByPath = @{}
    foreach ($relative in $index.Relative) {
        $heading = [regex]::Match([System.IO.File]::ReadAllText([System.IO.Path]::Combine($index.Root, $relative)), '(?m)^## Rules: (?<code>\S+)\s*$')
        if ($heading.Success) {
            $rulesHeadingByPath[$relative] = $heading.Groups['code'].Value
        }
    }

    $registeredKeys = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::Ordinal)
    foreach ($ruleSet in $ruleSets) {
        $key = "$($ruleSet.Domain)/$($ruleSet.Slug)"
        [void]$registeredKeys.Add($key)
        $files = @(if ($index.ByKey.ContainsKey($key)) {
                $index.ByKey[$key]
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

    # Each check has one mode setting and the same handling, so a new check is an entry here, not new code.
    # [ADR-PRIN-CONFIG#1](/docs/adr/principles/configure-not-program.md#rule-adr-prin-config1)
    # [comment:4](/docs/references/automation/catzc-base-docs/Test-AdrRegistry.ps1.md#comment4)
    $configured = @(
        [pscustomobject]@{
            Name     = 'citation-graph'
            Fact     = 'CitationGraph'
            Mode     = $checks.citation_graph.mode
            Findings = [string[]] @(Get-AdrCitationGraphViolations -Adrs $adrs -Index $index)
        }
        [pscustomobject]@{
            Name     = 'dora-coverage'
            Fact     = 'DoraCoverage'
            Mode     = $checks.dora_coverage.mode
            Findings = [string[]] @(Get-AdrDoraCoverageViolations -Adrs $adrs -Index $index -Settings $checks.dora_coverage)
        }
    )
    $facts = [ordered]@{ RuleSets = $ruleSets.Count; Files = $index.Relative.Count }
    foreach ($check in $configured) {
        $facts["$($check.Fact)Mode"] = $check.Mode.ToString().ToLowerInvariant()
        $facts["$($check.Fact)Findings"] = $check.Findings.Count
        if ($check.Mode -eq [Catzc.Base.Docs.CheckMode]::Gate) {
            $issues.AddRange($check.Findings)
            continue
        }
        # A check reporting on its own writes under the caller's folder when one is given, else under its subject's default.
        $checkFolder = if ($OutputFolder) {
            Join-Path $OutputFolder "adr-$($check.Name)"
        }
        else {
            ''
        }
        [void](Write-QualityGateReport -Subject "adr-$($check.Name)" -Title "Test-AdrRegistry $($check.Name) (report mode)" `
                -Issues $check.Findings -OutputFolder $checkFolder -PassThru)
    }

    $result = Write-QualityGateReport -Subject 'adr-registry' -Title 'Test-AdrRegistry' -Issues $issues -Facts $facts `
        -OutputFolder $OutputFolder -PassThru:$PassThru
    if ($PassThru) {
        foreach ($check in $configured) {
            $result | Add-Member -NotePropertyName $check.Fact -NotePropertyValue $check.Findings
        }
        $result
    }
}
