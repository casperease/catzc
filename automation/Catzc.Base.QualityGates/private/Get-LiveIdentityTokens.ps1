<#
.SYNOPSIS
    Derives the set of LIVE production identity tokens — the customers, subscriptions, org, deployable units,
    template names, and ADO project the shipped config maps to — that a hermetic LOGIC test must never name.
.DESCRIPTION
    The authoritative source of "what is a live identity" is the shipped config itself, not a hand-kept list: reading...
    [ADR-CONF-LOADING](/docs/adr/configuration/module-config-loading.md),
    [ADR-REPO-LANG](/docs/adr/repository/domain-language-separation.md),
    [ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)
    [comment:1](/docs/references/automation/catzc-base-qualitygates/private/Get-LiveIdentityTokens.ps1.md#comment1)
.OUTPUTS
    [object[]] One record per token: @{ Token; Kind; Source; Suggest }.
#>
function Get-LiveIdentityTokens {
    [CmdletBinding()]
    [OutputType([object[]])]
    param()

    $ret = [System.Collections.Generic.List[object]]::new()
    $seen = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
    # MatchMode governs HOW the finder matches a token: 'exact' — a distinctive identity flagged wherever it appears...
    # [comment:2](/docs/references/automation/catzc-base-qualitygates/private/Get-LiveIdentityTokens.ps1.md#comment2)
    $add = {
        param($token, $kind, $source, $suggest, $matchMode = 'exact')
        $value = "$token"
        if (-not [string]::IsNullOrWhiteSpace($value) -and $seen.Add($value)) {
            $ret.Add([pscustomobject]@{ Token = $value; Kind = $kind; Source = $source; Suggest = $suggest; MatchMode = $matchMode })
        }
    }

    # A config node's child by key, and its entries, whether the node is parsed YAML or a typed config object.
    $childOf = {
        param($node, [string] $key)
        if ($node -is [System.Collections.IDictionary]) {
            if ($node.Contains($key)) {
                $node[$key]
            }
        }
        elseif ($null -ne $node -and $node.PSObject.Properties[$key]) {
            $node.$key
        }
    }
    $isSkipped = {
        param($entry, [string] $skipWhen)
        $skipWhen -and [bool] (& $childOf $entry $skipWhen)
    }
    # Walks one rule's path from a node: a key segment steps in, a '*' steps into every entry of a map (leaving out...
    # [comment:3](/docs/references/automation/catzc-base-qualitygates/private/Get-LiveIdentityTokens.ps1.md#comment3)
    $walk = {
        param($node, [string[]] $path, [int] $depth, $rule)
        if ($null -eq $node) {
            return
        }
        if ($depth -eq $path.Count) {
            if ($rule.take -eq 'keys') {
                if ($node -is [System.Collections.IDictionary]) {
                    foreach ($key in @($node.Keys)) {
                        if (-not (& $isSkipped $node[$key] $rule.skip_when)) {
                            $key
                        }
                    }
                }
            }
            elseif ($node -isnot [System.Collections.IDictionary] -and $node -isnot [System.Collections.IList]) {
                $node
            }
            return
        }
        if ($path[$depth] -ne '*') {
            & $walk (& $childOf $node $path[$depth]) $path ($depth + 1) $rule
            return
        }
        if ($node -is [System.Collections.IDictionary]) {
            foreach ($key in @($node.Keys)) {
                if (-not (& $isSkipped $node[$key] $rule.skip_when)) {
                    & $walk $node[$key] $path ($depth + 1) $rule
                }
            }
        }
    }

    # The identities each owning module declares about its own configs (configs/identity-tokens.yml): customers, the...
    # [comment:4](/docs/references/automation/catzc-base-qualitygates/private/Get-LiveIdentityTokens.ps1.md#comment4)
    foreach ($owner in @(Get-Config -Config identity-tokens -ListOwners)) {
        $declaration = Get-Config -Config identity-tokens -Module $owner.Module
        foreach ($rule in $declaration.tokens) {
            $configOwners = @(Get-Config -Config $rule.config -ListOwners | ForEach-Object { $_.Module })
            if ($owner.Module -notin $configOwners) {
                throw "$($owner.Module)/configs/identity-tokens.yml declares tokens of config '$($rule.config)', which $($owner.Module) does not own; a module declares the identities of its own configs only."
            }
            $config = Get-Config -Config $rule.config
            foreach ($token in @(& $walk $config ([string[]] @($rule.path)) 0 $rule)) {
                & $add $token $rule.kind "$($rule.config).yml" $rule.suggest $rule.match
            }
        }
    }

    # NOTE: deployable-unit and pipeline names (globs.yml) are deliberately NOT included in Stage 1.
    # [comment:5](/docs/references/automation/catzc-base-qualitygates/private/Get-LiveIdentityTokens.ps1.md#comment5)

    # Shipped template names (infrastructure/templates/<name>).
    $templatesRoot = Join-Path (Get-RepositoryRoot) 'infrastructure/templates'
    if ([System.IO.Directory]::Exists($templatesRoot)) {
        foreach ($dir in [System.IO.Directory]::EnumerateDirectories($templatesRoot)) {
            & $add ([System.IO.Path]::GetFileName($dir)) 'template' 'infrastructure/templates' 'a fixture template (sample)'
        }
    }

    , $ret.ToArray()
}
