<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/Test-Terminology.ps1
    name: test-terminology
    filetype: ps1
    kind: function
    subkind: gate
    language: powershell
    track: automation
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
    relatives:
      page: docs/references/automation/catzc-base-qualitygates/Test-Terminology.ps1.md
      test: automation/Catzc.Base.QualityGates/tests/Test-Terminology.Tests.ps1
    adrs:
      - ADR-AUTO-SPELL
      - ADR-AUTO-TEST#35
  config:
    synopsis: 'Checks the terminology registry: no drift, no orphans, no unjustified entries. Writes a report under out/.'
    description: |-
      The read-only verifier over configs/terminology.yml and its generated dictionary — the counterpart to
      Build-TerminologyDictionary. It enforces the three things code review cannot mechanically catch
      ([ADR-AUTO-SPELL](/docs/adr/automation/spell-out-names.md),
      [ADR-AUTO-SPELL#5](/docs/adr/automation/spell-out-names.md#rule-adr-auto-spell5)-[ADR-AUTO-SPELL#8](/docs/adr/automation/spell-out-names.md#rule-adr-auto-spell8)):

        1. No drift — the generated per-category dictionaries (.cspell/<category>.txt) match what
           Build-TerminologyDictionary would produce from the registry
           ([ADR-AUTO-SPELL#5](/docs/adr/automation/spell-out-names.md#rule-adr-auto-spell5)). They are
           gitignored and
           regenerated on import, so this catches a hand-edited word list.
        2. No orphans — every registry entry is referenced somewhere in the spell-scanned tree; an entry no
           code uses is dead vocabulary and must be removed
           ([ADR-AUTO-SPELL#8](/docs/adr/automation/spell-out-names.md#rule-adr-auto-spell8)).
        3. No unjustified entry — every entry declares a category and a meaning, and every abbreviation carries
           its expansion ([ADR-AUTO-SPELL#6](/docs/adr/automation/spell-out-names.md#rule-adr-auto-spell6)).
           This is enforced by the TerminologyConfig type at load, so a malformed
           registry fails to load and is reported here.

      A quality gate ([ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35)): it ends
      through Write-QualityGateReport, which writes out/test-terminology/, prints every issue, and throws once
      listing them all; -PassThru returns the result object instead.

      It needs the source tree: it scans the catzc repository, so it throws in build mode (Assert-SourceTree).
    parameters:
      OutputFolder: The report base folder. Defaults to <out>/test-terminology.
      PassThru: Return a result object ({ Subject, IssueCount, Issues, ReportPath, TermCount }) instead of throwing.
    outputs: Throws on any issue; with -PassThru, returns the result object.
    examples:
      - Test-Terminology
      - '$result = Test-Terminology -PassThru; $result.IssueCount'
---
#>

function Test-Terminology {
    [CmdletBinding()]
    param(
        [string] $OutputFolder,

        [switch] $PassThru
    )

    # The orphan check searches the catzc source tree for each term, so it is meaningless over an installed build.
    Assert-SourceTree

    $root = Get-RepositoryRoot
    $registryPath = Join-Path $root 'automation/Catzc.Base.QualityGates/configs/terminology.yml'
    $issues = [System.Collections.Generic.List[string]]::new()

    $config = $null
    try {
        $config = Get-Config -Config terminology
    }
    catch {
        $issues.Add("registry does not validate (ADR-AUTO-SPELL#6): $($_.Exception.Message)")
    }

    if ($config) {
        $generated = Build-TerminologyDictionary -DryRun -PassThru
        foreach ($stale in @($generated | Where-Object Changed)) {
            $issues.Add(
                "dictionary drift (ADR-AUTO-SPELL#5): .cspell/$($stale.Category).txt is out of date — " +
                'regenerate it with Build-TerminologyDictionary (or re-run the importer).'
            )
        }

        $cspellDir = Join-Path $root '.cspell'
        $dictPaths = @($config.categories | ForEach-Object { Join-Path $cspellDir "$_.txt" })
        $corpus = Get-TerminologyCorpus -Root $root -Exclude (@($registryPath) + $dictPaths)
        foreach ($term in $config.terms) {
            if (-not $corpus.Contains($term.term.ToLowerInvariant())) {
                $issues.Add(
                    "orphan (ADR-AUTO-SPELL#8): '$($term.term)' is not referenced anywhere in the tree — remove it " +
                    'from terminology.yml.'
                )
            }
        }
    }

    $termCount = if ($config) {
        $config.terms.Count
    }
    else {
        0
    }

    Write-QualityGateReport -Subject terminology -Title Test-Terminology -Issues $issues.ToArray() `
        -Facts ([ordered]@{ TermCount = $termCount }) -OutputFolder $OutputFolder -PassThru:$PassThru
}
