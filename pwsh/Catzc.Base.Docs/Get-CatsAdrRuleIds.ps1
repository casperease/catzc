<#
---
catzc:
  immutable:
    with_body_sha: "6f63fb1d1b87"
  edges:
    test: pwsh/Catzc.Base.Docs/tests/Get-CatsAdrRuleIds.Tests.ps1
    docs: "[Get-CatsAdrRuleIds.ps1.md](docs/references/pwsh/catzc-base-docs/Get-CatsAdrRuleIds.ps1.md)"
    cites:
      - ADR-AUTO-CACHE
      - ADR-AUTO-NOPWD-NOWORKINGDIRECTORYPATHS
      - ADR-PWSH-CACHE-STRICTSAFEPROBE
      - ADR-PWSH-ERROR-THROWNOTWRITEERROR
      - PDR-REDUCEVAR
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
