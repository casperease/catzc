<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Docs/Test-AdrRegistry.ps1
    kind: function
    subkind: gate
    language: powershell
    filekind: ps1
    track: automation
    module: Catzc.Base.Docs
    visibility: public
    relatives:
      page: docs/references/automation/catzc-base-docs/Test-AdrRegistry.ps1.md
      test: automation/Catzc.Base.Docs/tests/Test-AdrRegistry.Tests.ps1
    adrs:
      - ADR-AUTO-TEST#35
      - ADR-PRIN-CONFIG#1
  config:
    synopsis: 'Quality gate: the ADR registry (adrs.yml) and the ADR rule files under docs/adr/ agree.'
    description: |-
      A quality gate ([ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35)) over the ADR
      registry (Get-Config -Config adrs, an AdrsConfig) and the ADR files it registers. An ADR rule file is a
      docs/adr/**/*.md that declares a `## Rules: <code>` registry; the other files there (the generated index and
      glossary, each domain's dora-explains.md, a folder's index.md or README.md) carry none and are out of scope.
      It collects an issue when:

        - a rule set has no file docs/adr/<domain>/**/<slug>.md, or more than one;
        - a rule set's file does not head its registry `## Rules: <External>` with the registered external code;
        - a rule file is registered by no rule set (its `<domain folder>/<slug>` is not in adrs.yml).

      It also runs two checks whose mode is configured in adr-checks.yml (Catzc.Base.Docs.AdrChecksConfig):

        - citation graph (citation_graph): a rule summary cites only its own domain or a domain in its domain's depends_on
          (Get-AdrCitationGraphViolations);
        - DORA coverage (dora_coverage): every rule set whose domain is not exempt has exactly one section linking its ADR in its
          domain's DORA file (Get-AdrDoraCoverageViolations).

      A check in gate mode adds its findings to this gate's issues. A check in report mode writes its own report
      (out/test-adr-<check>/, Write-QualityGateReport), prints its findings and their count, and never fails the run.

      The registry's own invariants (unique external codes, domain links that are declared and acyclic) are AdrsConfig
      construction rules, not this gate's.
    parameters:
      OutputFolder: |-
        The report base folder. Defaults to out/test-adr-registry/ (Write-QualityGateReport); a check in report mode writes under
        <OutputFolder>/adr-<check>/ when it is given, else under its own default folder.
      PassThru: |-
        Return the result instead of throwing on issues: { Subject; IssueCount; Issues; ReportPath; RuleSets; Files; CitationGraphMode;
        CitationGraphFindings; DoraCoverageMode; DoraCoverageFindings; CitationGraph; DoraCoverage }, where CitationGraph and
        DoraCoverage list each check's findings in either mode.
    outputs: '[pscustomobject] With -PassThru only.'
    examples:
      - Test-AdrRegistry
---
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
