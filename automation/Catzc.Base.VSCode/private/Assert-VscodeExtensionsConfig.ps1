<#
.SYNOPSIS
    Validates the vscode-extensions registry — the binding shape check Get-Config dispatches by convention.
.DESCRIPTION
    Runs once on the cache miss when Get-Config -Config vscode-extensions loads the registry (see
    docs/adr/configuration/module-config-loading.md). Collects every violation and throws once with the full
    list: 'recommendations' must be a non-empty list of unique publisher.name extension ids (lowercase-safe
    id characters around a single dot).
.PARAMETER Config
    The parsed ordered dictionary to validate.
.OUTPUTS
    None. Throws on the first invalid registry, naming every violation.
#>
function Assert-VscodeExtensionsConfig {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [System.Collections.IDictionary] $Config
    )

    $violations = [System.Collections.Generic.List[string]]::new()

    $recommendations = if ($Config.Contains('recommendations')) {
        @($Config['recommendations'])
    }
    else {
        @()
    }
    if ($recommendations.Count -eq 0) {
        $violations.Add("'recommendations' must be a non-empty list of extension ids")
    }

    $seen = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
    foreach ($id in $recommendations) {
        if ($id -isnot [string] -or $id -notmatch '^[A-Za-z0-9][\w-]*\.[A-Za-z0-9][\w-]*$') {
            $violations.Add("'$id' is not a publisher.name extension id")
            continue
        }
        if (-not $seen.Add($id)) {
            $violations.Add("duplicate recommendation '$id'")
        }
    }

    if ($violations.Count -gt 0) {
        throw "vscode-extensions config validation failed:`n$($violations -join "`n")"
    }
}
