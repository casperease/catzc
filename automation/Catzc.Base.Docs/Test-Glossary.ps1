<#
.SYNOPSIS
    Checks the controlled vocabulary against the repository: every glossary gate, every issue in one report.
.DESCRIPTION
    Runs the glossary gates of [ADR-REPO-VOCAB](/docs/adr/repository/controlled-vocabulary.md) over every glossary
    source, in order:
      - G1 — the facts that span sources (Get-GlossarySourceViolations);
      - G2 — every term anchored on its defining rule (Get-GlossaryAnchorViolations);
      - G3 — no second rule defining a term (Get-GlossaryDefinitionViolations);
      - G4 — no avoided phrasing used within a source's scope (Get-GlossaryPhrasingViolations);
      - G5 — every realized concept enforced (Get-GlossaryEnforcementViolations).
    Each source's own shape is validated when it loads (Catzc.Base.Docs.GlossaryConfig), so a malformed source
    fails before any gate runs. Writes out/test-glossary/<yyyyMMdd-HHmmss>/glossary.md (and latest.txt beside the
    run folders), prints the report path, and throws once with every issue in the message
    ([ADR-AUTO-FAILFAST](/docs/adr/automation/fail-fast-with-asserts.md)).
    The gates read the source tree's ADRs, tests, and tracked files, so it runs in source mode only.
.PARAMETER OutputFolder
    Folder for the timestamped report. Defaults to out/test-glossary under the repository output root.
.PARAMETER PassThru
    Returns { IssueCount; ConceptCount; SourceCount; Issues; ReportPath } instead of throwing on issues.
.OUTPUTS
    [pscustomobject] With -PassThru only.
.EXAMPLE
    Test-Glossary
.EXAMPLE
    (Test-Glossary -PassThru).Issues
#>
function Test-Glossary {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [string] $OutputFolder,

        [switch] $PassThru
    )

    Assert-SourceTree

    $sources = @(Get-GlossarySources)
    $entries = Get-Glossary
    $issues = [System.Collections.Generic.List[string]]::new()
    foreach ($issue in @(Get-GlossarySourceViolations -Source $sources)) {
        $issues.Add("G1 $issue")
    }
    foreach ($issue in @(Get-GlossaryAnchorViolations -Entry $entries)) {
        $issues.Add("G2 $issue")
    }
    foreach ($issue in @(Get-GlossaryDefinitionViolations -Entry $entries)) {
        $issues.Add("G3 $issue")
    }
    foreach ($issue in @(Get-GlossaryPhrasingViolations -Entry $entries)) {
        $issues.Add("G4 $issue")
    }
    foreach ($issue in @(Get-GlossaryEnforcementViolations -Entry $entries)) {
        $issues.Add("G5 $issue")
    }

    if (-not $OutputFolder) {
        $OutputFolder = Join-Path (Get-OutputRoot -EnsureExists) 'test-glossary'
    }
    $stamp = Get-Date -Format 'yyyyMMdd-HHmmss'
    $runDir = Join-Path $OutputFolder $stamp
    $i = 2
    while (Test-Path $runDir) {
        $runDir = Join-Path $OutputFolder "$stamp-$i"
        $i++
    }
    New-Item -ItemType Directory -Path $runDir -Force | Out-Null

    $lines = [System.Collections.Generic.List[string]]::new()
    $lines.Add('# Glossary report')
    $lines.Add('')
    $lines.Add("- Generated: $stamp")
    $lines.Add("- Sources: $($sources.Count)")
    $lines.Add("- Concepts: $($entries.Count)")
    if ($issues.Count -eq 0) {
        $lines.Add('- Result: no glossary issues')
    }
    else {
        $lines.Add("- Issues: $($issues.Count)")
        $lines.Add('')
        $lines.Add('## Issues')
        $lines.Add('')
        foreach ($issue in $issues) {
            $lines.Add("- $issue")
        }
    }
    Set-Content -Path (Join-Path $runDir 'glossary.md') -Value $lines -Encoding utf8
    Set-Content -Path (Join-Path $OutputFolder 'latest.txt') -Value (Split-Path $runDir -Leaf) -Encoding utf8

    if ($issues.Count -eq 0) {
        Write-Message "No glossary issues found across $($entries.Count) concept(s) in $($sources.Count) source(s)."
    }
    else {
        foreach ($issue in $issues) {
            Write-Message $issue -NoHeader
        }
        Write-Message "$($issues.Count) glossary issue(s)."
    }
    Write-Message "Glossary report: $runDir" -ForegroundColor Cyan -NoHeader

    if ($PassThru) {
        return [pscustomobject]@{
            IssueCount   = $issues.Count
            ConceptCount = $entries.Count
            SourceCount  = $sources.Count
            Issues       = $issues.ToArray()
            ReportPath   = $runDir
        }
    }

    if ($issues.Count -gt 0) {
        throw "Test-Glossary failed: $($issues.Count) issue(s) — see $runDir`n$($issues -join "`n")"
    }
}
