<#
---
catzc:
  immutable:
    with_body_sha: "01490963d387"
  edges:
    docs: "[Get-AdrCodeLanguageViolations.ps1.md](docs/references/pwsh/catzc-base-docs/private/Get-AdrCodeLanguageViolations.ps1.md)"
    cites:
      - ADR-REPO-ADRCODE-PATHOFSEGMENTS
      - ADR-REPO-ADRCODE-DOMAINSEGMENT
      - ADR-REPO-ADRCODE-NAMEDNOTNUMBERED
      - ADR-REPO-ADRCODE-ONESTRINGONEFACT
---
#>

function Get-AdrCodeLanguageViolations {
    [OutputType([string[]])]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [Catzc.Base.Docs.AdrsConfig] $Adrs,

        [Parameter(Mandatory)]
        [pscustomobject] $Index
    )

    $segment = '[A-Z][A-Z0-9]*'
    $codes = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::Ordinal)
    foreach ($ruleSet in $Adrs.RuleSets) {
        [void]$codes.Add($ruleSet.External)
    }

    $cited = "^$($Adrs.CodeForm.Cited)\z"
    $numberedRule = "^$($Adrs.CodeForm.Kind)-[A-Z0-9-]+:[0-9]+\z"
    $ret = foreach ($domain in $Adrs.Domains) {
        # A domain code of several segments is one finding; its ADRs are held to its first segment. A kind one domain owns has no domain code.
        $prefix = $domain.Kind
        if ($domain.Code) {
            $prefix = "$($domain.Kind)-$($domain.Code.Split('-')[0])"
            if ($domain.Code -cnotmatch "^$segment\z") {
                "$($domain.Name): domain code $($domain.Code) is not one segment (ADR-REPO-ADRCODE-DOMAINSEGMENT)"
            }
        }
        foreach ($ruleSet in $domain.RuleSets) {
            $code = $ruleSet.External
            if ($code -cnotmatch $cited) {
                "${code} ($($domain.Name)): not a path of upper-case segments after a registered kind (ADR-REPO-ADRCODE-PATHOFSEGMENTS)"
                continue
            }
            if (-not $code.StartsWith("$prefix-", [System.StringComparison]::Ordinal)) {
                "${code} ($($domain.Name)): does not start with its domain's prefix, $prefix- (ADR-REPO-ADRCODE-DOMAINSEGMENT)"
            }
            if (-not $Index.FileOf.ContainsKey($code)) {
                continue
            }

            $relative = $Index.FileOf[$code]
            $numbered = 0
            $inFence = $false
            $lines = [System.IO.File]::ReadAllLines([System.IO.Path]::Combine($Index.Root, $relative))
            for ($i = 0; $i -lt $lines.Count; $i++) {
                $line = $lines[$i]
                if ($line -match '^\s*(```|~~~)') {
                    $inFence = -not $inFence
                    continue
                }
                if ($inFence) {
                    continue
                }
                $heading = [regex]::Match($line, '^### Rule (?<rule>\S+)\s*$')
                if (-not $heading.Success) {
                    continue
                }
                $rule = $heading.Groups['rule'].Value
                if ($rule -cmatch $numberedRule) {
                    $numbered++
                    continue
                }
                if ($rule -cnotmatch "^$([regex]::Escape($code))-$segment\z") {
                    "$($Adrs.Root)/${relative}:$($i + 1): '### Rule $rule' is not $code plus one named segment (ADR-REPO-ADRCODE-NAMEDNOTNUMBERED)"
                    continue
                }
                if ($codes.Contains($rule)) {
                    "$($Adrs.Root)/${relative}:$($i + 1): rule $rule shares its name with the ADR $rule (ADR-REPO-ADRCODE-ONESTRINGONEFACT)"
                }
            }
            if ($numbered -gt 0) {
                "$($Adrs.Root)/${relative}: $numbered numbered rule heading(s); a rule is named, never numbered (ADR-REPO-ADRCODE-NAMEDNOTNUMBERED)"
            }
        }
    }

    [string[]] @($ret)
}
