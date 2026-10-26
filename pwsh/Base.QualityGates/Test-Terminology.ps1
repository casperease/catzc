<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-quality-gates/Test-Terminology.ps1.md"
  header: "generated"
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
    $issues = [System.Collections.Generic.List[string]]::new()

    # Check 3, no coinage: loading TerminologyConfig validates every entry and throws on a gap.
    $config = $null
    try {
        $config = Get-Config -Config terminology
    }
    catch {
        $issues.Add("registry does not validate (ADR-AUTO-SPELL-CATEGORYANDMEANING): $($_.Exception.Message)")
    }

    if ($config) {
        # Check 1, no drift: every generated dictionary matches the registry.
        $generated = Build-TerminologyDictionary -DryRun -PassThru
        foreach ($stale in @($generated | Where-Object Changed)) {
            $issues.Add(
                "dictionary drift (ADR-AUTO-SPELL-ONEVOCABULARYSOURCE): .cspell/$($stale.Category).txt is out of date — " +
                'regenerate it with Build-TerminologyDictionary (or re-run the importer).'
            )
        }

        $qualityGates = Join-Path $root "$(Get-CatzcModulesFolder)/$((Get-Track -Name pwsh).FolderNameOf('Catzc.Base.QualityGates'))"
        $corpus = Get-TerminologyCorpus -Root $root -Exclude $config.DefiningFiles($root, $qualityGates)
        # Check 2, no orphans: every term is referenced elsewhere, found in one bulk scan.
        foreach ($term in $config.terms) {
            if (-not $corpus.Contains($term.term.ToLowerInvariant())) {
                $issues.Add(
                    "orphan (ADR-AUTO-SPELL-LIVEVOCABULARYONLY): '$($term.term)' is not referenced anywhere in the tree — remove it " +
                    'from terminology.yml.'
                )
            }
        }

        # A reserved term stands only in its scope's files, matched ignoring case.
        $reserved = @($config.terms | Where-Object { $_.category -ceq 'reserved' })
        if ($reserved.Count -gt 0) {
            $allowed = @(if ($config.categoryScopes.ContainsKey('reserved')) {
                    $config.categoryScopes['reserved'] |
                        ForEach-Object { [Catzc.Base.Objects.GlobPattern]::new($_.ToLowerInvariant()) }
                })
            foreach ($relative in @(Get-GitTrackedPath '.')) {
                $lowered = $relative.ToLowerInvariant()
                if (@($allowed | Where-Object { $_.Matches($lowered) }).Count -gt 0) {
                    continue
                }
                $full = Join-Path $root $relative
                if (-not [System.IO.File]::Exists($full)) {
                    continue
                }
                $text = [System.IO.File]::ReadAllText($full)
                foreach ($term in $reserved) {
                    if ($text -match "(?i)\b$([regex]::Escape($term.term))\b") {
                        $issues.Add(
                            "reserved: '$($term.term)' appears in $relative, outside the scope of the 'reserved' category — use the word only " +
                            'where it names its one thing, or add the file to the scope in terminology.yml.'
                        )
                    }
                }
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
