<#
.SYNOPSIS
    Checks the controlled vocabulary against the repository: every glossary check, every issue in one report.
.DESCRIPTION
    Runs the glossary checks of over every glossary source, in order: - G1 — the facts that span more than one source...
    [ADR-REPO-VOCAB](/docs/adr/repository/controlled-vocabulary.md),
    [ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35),
    [ADR-AUTO-FAILFAST](/docs/adr/automation/fail-fast-with-asserts.md)
    [comment:1](/docs/references/automation/catzc-base-docs/Test-Glossary.ps1.md#comment1)
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
    $surfaces = @{}
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
    foreach ($issue in @(Get-GlossaryPhrasingViolations -Entry $entries -SurfaceCache $surfaces)) {
        $issues.Add("G4 $issue")
    }
    foreach ($issue in @(Get-GlossaryEnforcementViolations -Entry $entries)) {
        $issues.Add("G5 $issue")
    }
    foreach ($issue in @(Get-GlossaryFormViolations -Entry $entries -SurfaceCache $surfaces)) {
        $issues.Add("G6 $issue")
    }

    $facts = [ordered]@{
        SourceCount  = $sources.Count
        ConceptCount = $entries.Count
    }
    Write-QualityGateReport -Subject glossary -Title Test-Glossary -Issues $issues.ToArray() -Facts $facts `
        -OutputFolder $OutputFolder -PassThru:$PassThru
}
