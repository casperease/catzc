<#
---
catzc:
  immutable:
    with_body_sha: "9a200d16271d"
  edges:
    test: pwsh/Catzc.Base.Drs/tests/Get-CatsDrsRuleIds.Tests.ps1
    docs: "[Get-CatsDrsRuleIds.ps1.md](docs/references/pwsh/catzc-base-docs/Get-CatsDrsRuleIds.ps1.md)"
    cites:
      - ADR-AUTO-CACHE
      - ADR-AUTO-NOPWD-NOWORKINGDIRECTORYPATHS
      - ADR-PWSH-CACHE-STRICTSAFEPROBE
      - ADR-PWSH-ERROR-THROWNOTWRITEERROR
      - PDR-REDUCEVAR
---
#>

function Get-CatsDrsRuleIds {
    [OutputType([string[]])]
    [CmdletBinding()]
    param(
        [string] $IndexPath = (Resolve-RepoPath "$((Get-Config -Config drs).Root)/index.md")
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
    foreach ($entry in (Get-CatsDrsIndex -IndexPath $IndexPath)) {
        $adrFile = Join-Path $adrRoot $entry.Path
        foreach ($rule in (Get-CatsDrsRules -DrsPath $adrFile)) {
            [void]$ids.Add($rule.Id)
        }
    }

    $ret = @($ids | Sort-Object)
    $script:catsAdrRuleIdsCache[$IndexPath] = $ret
    , $ret
}
