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
    fails before any gate runs. A quality gate
    ([ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35)): it ends through
    Write-QualityGateReport, which writes out/test-glossary/, prints every issue, and throws once listing them all
    ([ADR-AUTO-FAILFAST](/docs/adr/automation/fail-fast-with-asserts.md)).
    The gates read the source tree's ADRs, tests, and tracked files, so it runs in source mode only.
.PARAMETER OutputFolder
    The report base folder. Defaults to out/test-glossary under the repository output root.
.PARAMETER PassThru
    Returns { Subject; IssueCount; Issues; ReportPath; ConceptCount; SourceCount } instead of throwing on issues.
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

    $facts = [ordered]@{
        SourceCount  = $sources.Count
        ConceptCount = $entries.Count
    }
    Write-QualityGateReport -Subject glossary -Title Test-Glossary -Issues $issues.ToArray() -Facts $facts `
        -OutputFolder $OutputFolder -PassThru:$PassThru
}
