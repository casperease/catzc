function Get-DrsCodeLanguageViolations {
    [OutputType([string[]])]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [Catzc.Base.Drs.DrsConfig] $Drs,

        [Parameter(Mandatory)]
        [pscustomobject] $Index
    )

    $segment = '[A-Z][A-Z0-9]*'
    $codes = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::Ordinal)
    foreach ($ruleSet in $Drs.RuleSets) {
        [void]$codes.Add($ruleSet.External)
    }

    $check = (Get-Config -Config drs-checks).code_language
    # External records keep the source's native ids (R01, RE01), which repeat by design; only catzc's own rule names are unique.
    $ruleNames = @{}
    $cited = "^$($Drs.CodeForm.Cited)\z"
    $numberedRule = "^$($Drs.CodeForm.Kind)-[A-Z0-9-]+:[0-9]+\z"
    $ret = foreach ($domain in $Drs.Domains) {
        # A domain code of several segments is one finding, its records held to its first; a kind one domain owns has no code.
        $prefix = $domain.Kind
        if ($domain.Code) {
            $prefix = "$($domain.Kind)-$($domain.Code.Split('-')[0])"
            if ($domain.Code -cnotmatch "^$segment\z") {
                "$($domain.Name): domain code $($domain.Code) is not one segment (ADR-REPO-DRSCODE-DOMAINSEGMENT)"
            }
        }
        foreach ($ruleSet in $domain.RuleSets) {
            $code = $ruleSet.External
            if ($code -cnotmatch $cited) {
                "${code} ($($domain.Name)): not a path of upper-case segments after a registered kind (ADR-REPO-DRSCODE-PATHOFSEGMENTS)"
                continue
            }
            if (-not $code.StartsWith("$prefix-", [System.StringComparison]::Ordinal)) {
                "${code} ($($domain.Name)): does not start with its domain's prefix, $prefix- (ADR-REPO-DRSCODE-DOMAINSEGMENT)"
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
                    "$($Drs.Root)/${relative}:$($i + 1): '### Rule $rule' is not $code plus one named segment (ADR-REPO-DRSCODE-NAMEDNOTNUMBERED)"
                    continue
                }
                if ($codes.Contains($rule)) {
                    "$($Drs.Root)/${relative}:$($i + 1): rule $rule shares its name with the record $rule (ADR-REPO-DRSCODE-ONESTRINGONEFACT)"
                }
                $budget = $check.Violation($rule, $true)
                if ($budget) {
                    "$($Drs.Root)/${relative}:$($i + 1): ${budget} (ADR-REPO-DRSCODE-RULENAMEBUDGET)"
                }
                if ($domain.Kind -cne 'EDR') {
                    $name = $rule.Substring($code.Length + 1)
                    if ($ruleNames.ContainsKey($name)) {
                        "$($Drs.Root)/${relative}:$($i + 1): rule name $name is also $($ruleNames[$name]) (ADR-REPO-DRSCODE-RULENAMESUNIQUE)"
                    }
                    else {
                        $ruleNames[$name] = $rule
                    }
                }
            }
            if ($numbered -gt 0) {
                "$($Drs.Root)/${relative}: $numbered numbered rule heading(s); a rule is named, never numbered (ADR-REPO-DRSCODE-NAMEDNOTNUMBERED)"
            }
        }
    }

    [string[]] @($ret)
}
