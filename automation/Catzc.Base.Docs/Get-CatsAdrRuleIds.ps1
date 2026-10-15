<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Docs/Get-CatsAdrRuleIds.ps1
    kind: public-function
    module: Catzc.Base.Docs
    visibility: public
    adrs:
      - ADR-AUTO-CACHE
      - ADR-AUTO-NOPWD#1
      - ADR-PRIN-REDUCEVAR
      - ADR-PWSH-CACHE#4
---
#>

<#
.SYNOPSIS
    The flat set of every declared ADR rule id across all ADRs (registry form, e.g. 'ADR-PWSH-ERROR:3').
.DESCRIPTION
    Ids come back in colon form, so a citation in hash form needs its separator swapped before the lookup.
.PARAMETER IndexPath
    ADR paths resolve against the index's own folder, so a test can pair a fixture index with fixture ADRs.
.OUTPUTS
    [string[]] the distinct rule ids in registry form (e.g. 'ADR-PWSH-ERROR:3'), ordinally sorted.
#>
function Get-CatsAdrRuleIds {
    [OutputType([string[]])]
    [CmdletBinding()]
    param(
        [string] $IndexPath = (Resolve-RepoPath 'docs/adr/index.md')
    )

    if ($null -eq $ExecutionContext.SessionState.PSVariable.GetValue('script:catsAdrRuleIdsCache')) {
        # GetValue gives null for an unset script variable, where a plain read would throw under strict mode.
        # [comment:3](/docs/references/automation/catzc-base-docs/Get-CatsAdrRuleIds.ps1.md#comment3)
        $script:catsAdrRuleIdsCache = @{}
    }
    if ($script:catsAdrRuleIdsCache.ContainsKey($IndexPath)) {
        return , $script:catsAdrRuleIdsCache[$IndexPath]
    }

    Assert-PathExist $IndexPath

    # Resolved against the index folder, not a hardcoded docs/adr, so a fixture index beside fixture ADRs works.
    # [comment:4](/docs/references/automation/catzc-base-docs/Get-CatsAdrRuleIds.ps1.md#comment4)
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
