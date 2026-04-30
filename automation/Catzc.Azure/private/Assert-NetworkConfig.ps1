<#
.SYNOPSIS
    Validates configs/network.yml and throws with all violations collected.
.DESCRIPTION
    Required shape:
      environments: map; name -> { vnet_address_space, default_subnet }

    Integrity rules:
    - names are valid lower-snake_case identifiers
    - vnet_address_space and default_subnet are IPv4 CIDR (a.b.c.d/n, 0 <= n <= 32)
    - cross-asset sync with azure.yml: every network environment is a defined azure.yml environment,
      and every *standard* azure.yml environment has a network entry (per-subscription envs subn/subp
      are exempt — they carry no vnet); and there is no plan for a ghost environment

    Auto-dispatched by Get-Config when loading the 'network' config.
#>
function Assert-NetworkConfig {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        $Config
    )

    if (-not $Config.Contains('environments')) {
        throw "network configuration validation failed:`nMissing required top-level key: 'environments'"
    }

    $errors = [System.Collections.Generic.List[string]]::new()

    # A valid IPv4 address followed by a 0-32 prefix length.
    $isValidCidr = {
        param($value)
        $parts = "$value" -split '/'
        if ($parts.Count -ne 2) {
            return $false
        }
        $ip = $null
        if (-not [System.Net.IPAddress]::TryParse($parts[0], [ref]$ip)) {
            return $false
        }
        if ($ip.AddressFamily -ne [System.Net.Sockets.AddressFamily]::InterNetwork) {
            return $false
        }
        $prefix = -1
        if (-not [int]::TryParse($parts[1], [ref]$prefix)) {
            return $false
        }
        ($prefix -ge 0 -and $prefix -le 32)
    }

    $identifierPattern = '^[a-z][a-z0-9_]*$'
    $envKeys = @($Config.environments.Keys)
    if ($envKeys.Count -eq 0) {
        $errors.Add('environments is empty')
    }

    foreach ($env in $envKeys) {
        if ($env -notmatch $identifierPattern) {
            $errors.Add("network environment '$env' is not a valid identifier (must match $identifierPattern)")
        }
        $entry = $Config.environments[$env]
        foreach ($key in 'vnet_address_space', 'default_subnet') {
            if (-not $entry.Contains($key)) {
                $errors.Add("network environment '$env' is missing '$key'")
            }
            elseif (-not (& $isValidCidr $entry[$key])) {
                $errors.Add("network environment '$env' has invalid $key '$($entry[$key])' (must be IPv4 CIDR, e.g. 10.10.0.0/16)")
            }
        }
    }

    # Cross-asset integrity: the IP plan and azure.yml's environments must stay in sync. Per-subscription
    # environments (subn/subp) are exempt — they identify a subscription (foundation: Log Analytics + Key
    # Vault) and carry no vnet, so they need no IP plan.
    $azure = Get-Config -Config azure
    $azureEnvs = @($azure.environments.Keys)
    foreach ($env in $envKeys) {
        if ($env -notin $azureEnvs) {
            $errors.Add("network environment '$env' is not a defined azure.yml environment (valid: $($azureEnvs -join ', '))")
        }
    }
    foreach ($env in $azureEnvs) {
        $azEnv = $azure.environments[$env]
        $isPerSub = ($azEnv.Contains('per_subscription') -and $azEnv['per_subscription'])
        if (-not $isPerSub -and $env -notin $envKeys) {
            $errors.Add("azure.yml environment '$env' has no network entry in network.yml")
        }
    }

    if ($errors.Count -gt 0) {
        throw "network configuration validation failed:`n$($errors -join "`n")"
    }
}
