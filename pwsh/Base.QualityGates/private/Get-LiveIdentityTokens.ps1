function Get-LiveIdentityTokens {
    [CmdletBinding()]
    [OutputType([object[]])]
    param()

    $ret = [System.Collections.Generic.List[object]]::new()
    $seen = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
    # 'exact' flags a literal anywhere; 'position' flags an ambiguous word only bound to an identity parameter.
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
    # A key steps in, '*' steps into every entry not set to skip, the path's end yields the value.
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

    # Each owning module declares the identities in its own configs.
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

    # Shipped template names (<templates place>/<name>).
    $templatesPlace = Get-TrackPlace -Track vendor_azure.bicep -TrackKind templates
    # Deployable-unit and pipeline names stay out: the generic ones are structural folder words.
    $templatesRoot = Join-Path (Get-RepositoryRoot) $templatesPlace
    if ([System.IO.Directory]::Exists($templatesRoot)) {
        foreach ($dir in Get-ChildPath $templatesRoot -Depth 1 -Directory -Exclude @() -PruneVendor $false) {
            & $add ([System.IO.Path]::GetFileName($dir)) 'template' $templatesPlace 'a fixture template (sample)'
        }
    }

    , $ret.ToArray()
}
