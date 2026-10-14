<#
.SYNOPSIS
    Returns the controlled vocabulary: every concept of every glossary source, merged and sorted by term.
.DESCRIPTION
    Merges the opting-in modules' configs/glossary.yml sources (Get-GlossarySources,
    [ADR-REPO-VOCAB#2](/docs/adr/repository/controlled-vocabulary.md#rule-adr-repo-vocab2)) into one
    list of Catzc.Base.Docs.GlossaryEntry: each concept with the module that declares it, that source's
    repo-relative path, and the source's defaulted options. Sorted by term (ordinal), so the result reads like a
    glossary and is stable across runs.

    Each source is validated on load by its type; the facts that span more than one source — a term or key
    declared twice, a contrast that is not reciprocal, a source git does not track — are not checked here. They
    belong to the glossary checks (Get-GlossarySourceViolations), so a reader always gets the vocabulary as
    declared.

    The result is cached for the session per repository root
    ([ADR-AUTO-PSCACHE](/docs/adr/automation/powershell/script-scope-caching.md)); re-run the importer to pick up
    an edited glossary. Callers treat it as read-only (the same array is returned on every call).
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
        # ([ADR-AUTO-PSCACHE#4](/docs/adr/automation/powershell/script-scope-caching.md#rule-adr-auto-pscache4))
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
