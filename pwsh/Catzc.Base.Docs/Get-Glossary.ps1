<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-docs/Get-Glossary.ps1.md"
  warning: "Generated Header"
---
#>

function Get-Glossary {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Docs.GlossaryEntry[]])]
    param()

    if ($null -eq $ExecutionContext.SessionState.PSVariable.GetValue('script:glossaryCache')) {
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
