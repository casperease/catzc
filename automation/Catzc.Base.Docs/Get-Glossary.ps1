<#
.SYNOPSIS
    Returns the controlled vocabulary: every concept of every glossary source, merged and sorted by term.
.DESCRIPTION
    Merges the opting-in modules' configs/glossary.yml sources (Get-GlossarySources, ) into one list of...
    [ADR-REPO-VOCAB#2](/docs/adr/repository/controlled-vocabulary.md#rule-adr-repo-vocab2),
    [ADR-PWSH-CACHE](/docs/adr/pwsh/script-scope-caching.md)
    [comment:1](/docs/references/automation/catzc-base-docs/Get-Glossary.ps1.md#comment1)
.OUTPUTS
    [Catzc.Base.Docs.GlossaryEntry[]] Empty when no module ships a glossary.
.EXAMPLE
    Get-Glossary | Format-Table { $_.Concept.term }, Owner, { $_.Concept.defined_by }
#>
function Get-Glossary {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Docs.GlossaryEntry[]])]
    param()

    if ($null -eq $ExecutionContext.SessionState.PSVariable.GetValue('script:glossaryCache')) {
        # strict-clean probe of the lazy cache entry
        # [ADR-PWSH-CACHE#4](/docs/adr/pwsh/script-scope-caching.md#rule-adr-pwsh-cache4)
        # [comment:2](/docs/references/automation/catzc-base-docs/Get-Glossary.ps1.md#comment2)
        $script:glossaryCache = @{}
    }
    $cacheKey = Get-RepositoryRoot
    if ($script:glossaryCache.ContainsKey($cacheKey)) {
        return , $script:glossaryCache[$cacheKey]
    }

    $entries = [System.Collections.Generic.List[Catzc.Base.Docs.GlossaryEntry]]::new()
    foreach ($source in @(Get-GlossarySources)) {
        foreach ($concept in $source.Config.concepts) {
            $entries.Add([Catzc.Base.Docs.GlossaryEntry]::new($concept, $source.Owner, $source.Path, $source.Config.options))
        }
    }

    $sorted = $entries.ToArray()
    $terms = [string[]] @(foreach ($entry in $sorted) {
            $entry.Concept.term
        })
    [System.Array]::Sort($terms, $sorted, [System.StringComparer]::Ordinal)

    $script:glossaryCache[$cacheKey] = $sorted
    , $sorted
}
