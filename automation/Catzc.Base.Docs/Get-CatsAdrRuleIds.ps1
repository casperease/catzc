<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Docs/Get-CatsAdrRuleIds.ps1
    kind: function
    language: powershell
    filekind: ps1
    track: automation
    module: Catzc.Base.Docs
    visibility: public
    relatives:
      page: docs/references/automation/catzc-base-docs/Get-CatsAdrRuleIds.ps1.md
      test: automation/Catzc.Base.Docs/tests/Get-CatsAdrRuleIds.Tests.ps1
    adrs:
      - ADR-AUTO-CACHE
      - ADR-AUTO-NOPWD#1
      - ADR-PRIN-REDUCEVAR
      - ADR-PWSH-CACHE#4
  config:
    synopsis: The flat set of every declared ADR rule id across all ADRs (registry form, e.g. 'ADR-PWSH-ERROR:3').
    description: |-
      Unions the rule ids of every ADR the index ([index](/docs/adr/index.md)) lists: for each index row
      (Get-CatsAdrIndex) it reads that ADR file (Get-CatsAdrRules) and collects the `### Rule <CODE>:<n>` ids,
      returning them distinct and ordinally sorted in registry form (colon, e.g. 'ADR-AUTO-NOPWD:1'). This is the
      authoritative set a rule citation is validated against — a test tag or an analyzer mapping that names a
      rule absent from this set is a dead reference.

      Ids are returned in registry (`:`) form; a caller comparing a citation, which is spelled in `#` form
      (e.g. 'ADR-AUTO-NOPWD#1', the
      [index](/docs/adr/index.md) citation grammar), canonicalizes the separator before lookup.

      A pure function of the files on disk, memoized per resolved index path for the session (re-run the
      importer to refresh — see
      [ADR-AUTO-CACHE](/docs/adr/automation/caching.md)). Built on the two existing ADR parsers rather
      than re-scanning the tree ([ADR-PRIN-REDUCEVAR](/docs/adr/principles/reduce-variability.md)).
    parameters:
      IndexPath: |-
        Absolute path to the ADR index. Defaults to [index](/docs/adr/index.md) under the repository root. ADR file paths in
        the index are resolved relative to the index's own folder, so a test can point this at a fixture index
        beside fixture ADR files; the cache keys on the path, so a fixture path and the real path never collide.
    outputs: '[string[]] the distinct rule ids in registry form (e.g. ''ADR-PWSH-ERROR:3''), ordinally sorted.'
---
#>

function Get-CatsAdrRuleIds {
    [OutputType([string[]])]
    [CmdletBinding()]
    param(
        [string] $IndexPath = (Resolve-RepoPath 'docs/adr/index.md')
    )

    if ($null -eq $ExecutionContext.SessionState.PSVariable.GetValue('script:catsAdrRuleIdsCache')) {
        $script:catsAdrRuleIdsCache = @{}
    }
    if ($script:catsAdrRuleIdsCache.ContainsKey($IndexPath)) {
        return , $script:catsAdrRuleIdsCache[$IndexPath]
    }

    Assert-PathExist $IndexPath

    $adrRoot = Split-Path $IndexPath -Parent
    $ids = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::Ordinal)
    foreach ($entry in (Get-CatsAdrIndex -IndexPath $IndexPath)) {
        $adrFile = Join-Path $adrRoot $entry.Path
        foreach ($rule in (Get-CatsAdrRules -AdrPath $adrFile)) {
            [void]$ids.Add($rule.Id)
        }
    }

    $ret = @($ids | Sort-Object)
    $script:catsAdrRuleIdsCache[$IndexPath] = $ret
    , $ret
}
