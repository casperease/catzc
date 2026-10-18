function Test-Glossary {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Reports.QualityGateResult])]
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
