<#
.SYNOPSIS
    Validates the vscode-launch registry — the binding shape check Get-Config dispatches by convention.
.DESCRIPTION
    Runs once on the cache miss when Get-Config -Config vscode-launch loads the registry (see
    docs/adr/automation/module-config-loading.md). Collects every violation and throws once with the full
    list: a non-empty 'version' string, plus a non-empty 'configurations' list where every entry is a map
    carrying non-empty 'name', 'type', and 'request', with names unique.
.PARAMETER Config
    The parsed ordered dictionary to validate.
.OUTPUTS
    None. Throws on the first invalid registry, naming every violation.
#>
function Assert-VscodeLaunchConfig {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [System.Collections.IDictionary] $Config
    )

    $violations = [System.Collections.Generic.List[string]]::new()

    $version = if ($Config.Contains('version')) { $Config['version'] } else { $null }
    if ($version -isnot [string] -or [string]::IsNullOrWhiteSpace($version)) {
        $violations.Add("'version' must be a non-empty string (VS Code launch schema version, e.g. '0.2.0')")
    }

    $configurations = if ($Config.Contains('configurations')) { @($Config['configurations']) } else { @() }
    if ($configurations.Count -eq 0) {
        $violations.Add("'configurations' must be a non-empty list of launch profiles")
    }

    $seen = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
    foreach ($launchProfile in $configurations) {
        if ($launchProfile -isnot [System.Collections.IDictionary]) {
            $violations.Add('each configurations entry must be a mapping')
            continue
        }
        foreach ($required in 'name', 'type', 'request') {
            $value = if ($launchProfile.Contains($required)) { $launchProfile[$required] } else { $null }
            if ($value -isnot [string] -or [string]::IsNullOrWhiteSpace($value)) {
                $violations.Add("a configurations entry is missing a non-empty '$required'")
            }
        }
        $name = if ($launchProfile.Contains('name')) { $launchProfile['name'] } else { $null }
        if ($name -is [string] -and -not [string]::IsNullOrWhiteSpace($name) -and -not $seen.Add($name)) {
            $violations.Add("duplicate configuration name '$name'")
        }
    }

    if ($violations.Count -gt 0) {
        throw "vscode-launch config validation failed:`n$($violations -join "`n")"
    }
}
