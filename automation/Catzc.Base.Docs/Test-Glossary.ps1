<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.Docs/Test-Glossary.ps1
    name: test-glossary
    filetype: ps1
    kind: function
    subkind: gate
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Docs
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: automation/Catzc.Base.Docs/tests/Test-Glossary.Tests.ps1
    cites:
      - ADR-AUTO-FAILFAST
      - ADR-AUTO-TEST#35
      - ADR-REPO-VOCAB
  config:
    synopsis: 'Checks the controlled vocabulary against the repository: every glossary check, every issue in one report.'
    description: |-
      Runs the glossary checks of [ADR-REPO-VOCAB](/docs/adr/repository/controlled-vocabulary.md) over every glossary
      source, in order:
        - G1 — the facts that span more than one source (Get-GlossarySourceViolations);
        - G2 — every term anchored on its defining rule (Get-GlossaryAnchorViolations);
        - G3 — no second rule defining a term (Get-GlossaryDefinitionViolations);
        - G4 — no avoided phrasing used within a source's scope (Get-GlossaryPhrasingViolations);
        - G5 — every realized concept enforced (Get-GlossaryEnforcementViolations);
        - G6 — no term qualified outside its declared forms (Get-GlossaryFormViolations).
      G4 and G6 read the same text surfaces of the same tracked files, so they share one surface table and each file's
      prose is read once per run.
      Each source's own shape is validated when it loads (Catzc.Base.Docs.GlossaryConfig), so a source that is
      malformed fails before any check runs. A quality gate
      ([ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35)): it ends through
      Write-QualityGateReport, which writes out/test-glossary/, prints every issue, and throws once listing them all
      ([ADR-AUTO-FAILFAST](/docs/adr/automation/fail-fast-with-asserts.md)).
      The checks read the source tree's ADRs, tests, and tracked files, so it runs in source mode only.
    parameters:
      OutputFolder: The report base folder. Defaults to out/test-glossary under the repository output root.
      PassThru: Returns { Subject; IssueCount; Issues; ReportPath; ConceptCount; SourceCount } instead of throwing on issues.
    outputs: '[pscustomobject] With -PassThru only.'
    examples:
      - Test-Glossary
      - (Test-Glossary -PassThru).Issues
---
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
