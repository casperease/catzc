<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.QualityGates/private/Get-LiveIdentityTokens.ps1
    folder: private
    name: get-live-identity-tokens
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    page: docs/references/automation/catzc-base-qualitygates/private/Get-LiveIdentityTokens.ps1.md
    test: automation/Catzc.Base.QualityGates/tests/Get-LiveIdentityTokens.Tests.ps1
    cites:
      - ADR-AUTO-TEST#3
      - ADR-CONF-LOADING
      - ADR-REPO-LANG
---
#>

function Get-LiveIdentityTokens {
    [CmdletBinding()]
    [OutputType([object[]])]
    param()

    $ret = [System.Collections.Generic.List[object]]::new()
    $seen = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
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

    # Shipped template names (infrastructure/templates/<name>).
    $templatesRoot = Join-Path (Get-RepositoryRoot) 'infrastructure/templates'
    if ([System.IO.Directory]::Exists($templatesRoot)) {
        foreach ($dir in [System.IO.Directory]::EnumerateDirectories($templatesRoot)) {
            & $add ([System.IO.Path]::GetFileName($dir)) 'template' 'infrastructure/templates' 'a fixture template (sample)'
        }
    }

    , $ret.ToArray()
}
