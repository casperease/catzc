<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.Docs/Get-Glossary.ps1
    name: get-glossary
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Docs
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    page: docs/references/automation/catzc-base-docs/Get-Glossary.ps1.md
    test: automation/Catzc.Base.Docs/tests/Get-Glossary.Tests.ps1
    cites:
      - ADR-PWSH-CACHE
      - ADR-REPO-VOCAB#2
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
