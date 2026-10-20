<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.QualityGates/Test-Terminology.ps1
    name: test-terminology
    filetype: ps1
    role: function
    subkind: gate
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: pwsh/Catzc.Base.QualityGates/tests/Test-Terminology.Tests.ps1
    docs: "[Test-Terminology.ps1.md](docs/references/pwsh/catzc-base-qualitygates/Test-Terminology.ps1.md)"
    cites:
      - ADR-AUTO-SPELL
      - ADR-AUTO-TEST-QUALITYGATE
---
#>

function Test-Terminology {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Reports.QualityGateResult])]
    param(
        [string] $OutputFolder,

        [switch] $PassThru
    )

    # The orphan check searches the catzc source tree for each term, so it is meaningless over an installed build.
    Assert-SourceTree

    $root = Get-RepositoryRoot
    $registryPath = Join-Path $root "$(Get-CatzcModulesFolder)/Catzc.Base.QualityGates/configs/terminology.yml"
    $issues = [System.Collections.Generic.List[string]]::new()

    $config = $null
    try {
        $config = Get-Config -Config terminology
    }
    catch {
        $issues.Add("registry does not validate (ADR-AUTO-SPELL-CATEGORYANDMEANING): $($_.Exception.Message)")
    }

    if ($config) {
        $generated = Build-TerminologyDictionary -DryRun -PassThru
        foreach ($stale in @($generated | Where-Object Changed)) {
            $issues.Add(
                "dictionary drift (ADR-AUTO-SPELL-ONEVOCABULARYSOURCE): .cspell/$($stale.Category).txt is out of date — " +
                'regenerate it with Build-TerminologyDictionary (or re-run the importer).'
            )
        }

        $cspellDir = Join-Path $root '.cspell'
        $dictPaths = @($config.categories | ForEach-Object { Join-Path $cspellDir "$_.txt" })
        $corpus = Get-TerminologyCorpus -Root $root -Exclude (@($registryPath) + $dictPaths)
        foreach ($term in $config.terms) {
            if (-not $corpus.Contains($term.term.ToLowerInvariant())) {
                $issues.Add(
                    "orphan (ADR-AUTO-SPELL-LIVEVOCABULARYONLY): '$($term.term)' is not referenced anywhere in the tree — remove it " +
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
