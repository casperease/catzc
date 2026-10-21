<#
---
catzc:
  immutable:
    with_body_sha: "502e5afe95a9"
  edges:
    test: pwsh/Catzc.Base.Drs/tests/Test-DrsRegistry.Tests.ps1
    docs: "[Test-DrsRegistry.ps1.md](../../docs/references/pwsh/catzc-base-drs/Test-DrsRegistry.ps1.md)"
    cites:
      - ADR-AUTO-TEST-QUALITYGATE
      - PDR-CONFIG-VARYINGBEHAVIOURISCONFIG
---
#>

function Test-DrsRegistry {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Reports.QualityGateResult])]
    param(
        [string] $OutputFolder,

        [switch] $PassThru
    )

    $adrs = Get-Config -Config drs
    $checks = Get-Config -Config drs-checks
    $ruleSets = @($adrs.RuleSets)
    $index = Get-DrsFileIndex $ruleSets -DrsRoot (Resolve-RepoPath $adrs.Root)
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
        $key = "$($ruleSet.Folder)/$($ruleSet.Slug)"
        [void]$registeredKeys.Add($key)
        $files = @(if ($index.ByKey.ContainsKey($key)) {
                $index.ByKey[$key]
            })
        if ($files.Count -eq 0) {
            $issues.Add("$($ruleSet.External): no ADR file $($adrs.Root)/$($ruleSet.Folder)/**/$($ruleSet.Slug).md")
            continue
        }
        if ($files.Count -gt 1) {
            $issues.Add("$($ruleSet.External): $($files.Count) ADR files named $($ruleSet.Slug).md under $($adrs.Root)/$($ruleSet.Folder)/ —$(($files | ForEach-Object { "$($adrs.Root)/$_" }) -join ', ')")
            continue
        }
        if ($rulesHeadingByPath[$files[0]] -cne $ruleSet.External) {
            $issues.Add("$($adrs.Root)/$($files[0]): must head its rule registry '## Rules: $($ruleSet.External)' (the drs.yml external code)")
        }
    }

    # The key the file index gave each page, so a page under a domain folder that points into another domain's folder is checked against its own domain.
    $keyOfPath = @{}
    foreach ($entry in $index.ByKey.GetEnumerator()) {
        foreach ($path in $entry.Value) {
            $keyOfPath[$path] = $entry.Key
        }
    }
    foreach ($relative in @($rulesHeadingByPath.Keys | Sort-Object)) {
        $key = $keyOfPath[$relative]
        if (-not $registeredKeys.Contains($key)) {
            $issues.Add("$($adrs.Root)/${relative}: declares '## Rules: $($rulesHeadingByPath[$relative])' but no drs.yml rule set registers it")
        }
    }

    $configured = @(
        [pscustomobject]@{
            Name     = 'citation-graph'
            Fact     = 'CitationGraph'
            Mode     = $checks.citation_graph.mode
            Findings = [string[]] @(Get-DrsCitationGraphViolations -Adrs $adrs -Index $index)
        }
        [pscustomobject]@{
            Name     = 'dora-coverage'
            Fact     = 'DoraCoverage'
            Mode     = $checks.dora_coverage.mode
            Findings = [string[]] @(Get-DrsDoraCoverageViolations -Adrs $adrs -Index $index -Settings $checks.dora_coverage)
        }
        [pscustomobject]@{
            Name     = 'code-language'
            Fact     = 'CodeLanguage'
            Mode     = $checks.code_language.mode
            Findings = [string[]] @(Get-DrsCodeLanguageViolations -Adrs $adrs -Index $index)
        }
    )
    $facts = [ordered]@{ RuleSets = $ruleSets.Count; Files = $index.Relative.Count }
    foreach ($check in $configured) {
        $facts["$($check.Fact)Mode"] = $check.Mode.ToString().ToLowerInvariant()
        $facts["$($check.Fact)Findings"] = $check.Findings.Count
        $facts[$check.Fact] = [string[]] $check.Findings
        if ($check.Mode -eq [Catzc.Base.Reports.CheckMode]::Gate) {
            $issues.AddRange($check.Findings)
            continue
        }
        # A check reporting on its own writes under the caller's folder when one is given, else under its subject's default.
        $checkFolder = if ($OutputFolder) {
            Join-Path $OutputFolder "drs-$($check.Name)"
        }
        else {
            ''
        }
        [void](Write-QualityGateReport -Subject "drs-$($check.Name)" -Title "Test-DrsRegistry $($check.Name) (report mode)" `
                -Issues $check.Findings -OutputFolder $checkFolder -PassThru)
    }

    Write-QualityGateReport -Subject 'drs-registry' -Title 'Test-DrsRegistry' -Issues $issues -Facts $facts `
        -OutputFolder $OutputFolder -PassThru:$PassThru
}
