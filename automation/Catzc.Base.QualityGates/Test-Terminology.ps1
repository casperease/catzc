<#
.SYNOPSIS
    Checks the terminology registry: no drift, no orphans, no unjustified entries. Writes a report under out/.
.DESCRIPTION
    Dictionaries are gitignored and regenerated on import, so a drift finding means a hand-edited word list.
    [ADR-AUTO-SPELL](/docs/adr/automation/spell-out-names.md),
    [ADR-AUTO-SPELL#5](/docs/adr/automation/spell-out-names.md#rule-adr-auto-spell5),
    [ADR-AUTO-SPELL#8](/docs/adr/automation/spell-out-names.md#rule-adr-auto-spell8),
    [ADR-AUTO-SPELL#6](/docs/adr/automation/spell-out-names.md#rule-adr-auto-spell6),
    [ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35)
    [comment:1](/docs/references/automation/catzc-base-qualitygates/Test-Terminology.ps1.md#comment1)
.PARAMETER OutputFolder
    The report base folder. Defaults to <out>/test-terminology.
.PARAMETER PassThru
    Return a result object ({ Subject, IssueCount, Issues, ReportPath, TermCount }) instead of throwing.
.OUTPUTS
    Throws on any issue; with -PassThru, returns the result object.
.EXAMPLE
    Test-Terminology
.EXAMPLE
    $result = Test-Terminology -PassThru; $result.IssueCount
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
    # It names the file in the scanned tree, not an asset read: the registry itself loads through Get-Config.
    # [comment:2](/docs/references/automation/catzc-base-qualitygates/Test-Terminology.ps1.md#comment2)
    $registryPath = Join-Path $root 'automation/Catzc.Base.QualityGates/configs/terminology.yml'
    $issues = [System.Collections.Generic.List[string]]::new()

    # A malformed entry fails at load through TerminologyConfig, so the load itself is the justification check.
    # [comment:3](/docs/references/automation/catzc-base-qualitygates/Test-Terminology.ps1.md#comment3)
    $config = $null
    try {
        $config = Get-Config -Config terminology
    }
    catch {
        $issues.Add("registry does not validate (ADR-AUTO-SPELL#6): $($_.Exception.Message)")
    }

    if ($config) {
        # Dictionaries are gitignored and regenerated on import, so a dry run that differs means a hand edit.
        # [ADR-AUTO-SPELL#5](/docs/adr/automation/spell-out-names.md#rule-adr-auto-spell5)
        # [comment:4](/docs/references/automation/catzc-base-qualitygates/Test-Terminology.ps1.md#comment4)
        $generated = Build-TerminologyDictionary -DryRun -PassThru
        foreach ($stale in @($generated | Where-Object Changed)) {
            $issues.Add(
                "dictionary drift (ADR-AUTO-SPELL#5): .cspell/$($stale.Category).txt is out of date — " +
                'regenerate it with Build-TerminologyDictionary (or re-run the importer).'
            )
        }

        # One bulk scan, then a lookup per term, not a grep per term; the registry and generated lists are excluded.
        # [ADR-AUTO-SPELL#8](/docs/adr/automation/spell-out-names.md#rule-adr-auto-spell8)
        # [comment:5](/docs/references/automation/catzc-base-qualitygates/Test-Terminology.ps1.md#comment5)
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
