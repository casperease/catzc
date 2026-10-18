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
        [pscustomobject]@{
            Name     = 'code-language'
            Fact     = 'CodeLanguage'
            Mode     = $checks.code_language.mode
            Findings = [string[]] @(Get-AdrCodeLanguageViolations -Adrs $adrs -Index $index)
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
