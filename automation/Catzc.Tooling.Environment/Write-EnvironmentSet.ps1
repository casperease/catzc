<#
---
catzc:
  derived:
    path: automation/Catzc.Tooling.Environment/Write-EnvironmentSet.ps1
    kind: function
    module: Catzc.Tooling.Environment
    visibility: public
    adrs:
      - ADR-AUTO-ENVVAR#7
---
#>

<#
.SYNOPSIS
    Prepares a set of $env: variables for a child or external process to read — the one sanctioned seam for
    handing a secret to an external consumer through the environment.
.DESCRIPTION
    A bare literal in -Set is rejected, so a literal is never mistaken for a secret or an address; use -Value.
.PARAMETER Set
    Map of env name (or subtree prefix) to a [SecureString] secret or a 'global.<config>...' config address.
.PARAMETER Value
    Map of env name to an explicit non-secret literal string.
.PARAMETER ScriptBlock
    Scoped lifetime: the variables are set only for the duration of this block, then restored.
.PARAMETER Persist
    Persist lifetime: the variables are set and left in place for the session/child process.
.EXAMPLE
    Write-EnvironmentSet -Set @{
        DB       = 'global.database'        # subtree -> DB_HOST, DB_PORT, DB_OPTIONS_SSL
        APP_NAME = 'global.myproperty.name' # scalar  -> APP_NAME
        GH_TOKEN = $secureToken             # secret  -> masked in logs
    } -Value @{ MY_FLAG = '1' } -ScriptBlock { Invoke-SomeContainer }
.EXAMPLE
    Write-EnvironmentSet -Set @{ GH_TOKEN = $secureToken } -Persist
#>
function Write-EnvironmentSet {
    [CmdletBinding(DefaultParameterSetName = 'Scoped')]
    param(
        [Parameter(Mandatory, Position = 0)]
        [System.Collections.IDictionary] $Set,

        [System.Collections.IDictionary] $Value,

        [Parameter(Mandatory, ParameterSetName = 'Scoped')]
        [scriptblock] $ScriptBlock,

        [Parameter(Mandatory, ParameterSetName = 'Persist')]
        [switch] $Persist
    )

    # Address is null unless the entry came from a config address; Origin names the source for the collision error.
    # [comment:2](/docs/references/automation/catzc-tooling-environment/Write-EnvironmentSet.ps1.md#comment2)
    $entries = [System.Collections.Generic.List[hashtable]]::new()

    foreach ($name in $Set.Keys) {
        $raw = $Set[$name]

        if ($raw -is [SecureString]) {
            $plain = [System.Net.NetworkCredential]::new('', $raw).Password
            $entries.Add(@{ Name = $name; Value = $plain; Secret = $true; Origin = 'secret'; Address = $null })
            continue
        }

        if ($raw -is [string] -and $raw -match '^global\.') {
            $node = Get-ConfigValue -Address $raw
            $isSubtree = $null -ne $node -and -not ($node -is [string]) -and -not $node.GetType().IsValueType

            if (-not $isSubtree) {
                $entries.Add(@{ Name = $name; Value = [string]$node; Secret = $false; Origin = "address '$raw'"; Address = $raw })
                continue
            }

            $flat = ConvertTo-FlatSettingSet $node
            if ($flat.Count -eq 0) {
                throw "Write-EnvironmentSet: address '$raw' (prefix '$name') resolved to a node that produced no values to expand."
            }
            foreach ($flatKey in $flat.Keys) {
                $envName = (("$name.$flatKey") -replace '\[(\d+)\]', '_$1' -replace '\.', '_').ToUpperInvariant()
                $entries.Add(@{ Name = $envName; Value = [string]$flat[$flatKey]; Secret = $false; Origin = "address '$raw'"; Address = $raw })
            }
            continue
        }

        $type = if ($null -eq $raw) {
            'null'
        }
        else {
            $raw.GetType().Name
        }
        throw "Write-EnvironmentSet: -Set entry '$name' is neither a [SecureString] secret nor a 'global.…' config address (got $type). Pass a non-secret literal through -Value."
    }

    if ($Value) {
        foreach ($name in $Value.Keys) {
            $entries.Add(@{ Name = $name; Value = [string]$Value[$name]; Secret = $false; Origin = "literal '-Value'"; Address = $null })
        }
    }

    # 2) A single env var must have exactly one source. Collisions across channels throw (poka-yoke).
    $origins = @{}
    foreach ($entry in $entries) {
        if ($origins.ContainsKey($entry.Name)) {
            throw "Write-EnvironmentSet: environment variable '$($entry.Name)' is assigned by more than one input ($($origins[$entry.Name]) and $($entry.Origin)); each env var must have exactly one source."
        }
        $origins[$entry.Name] = $entry.Origin
    }

    # Scoped and Persist share one set-and-log loop; only Scoped snapshots first and restores in a finally.
    # [comment:3](/docs/references/automation/catzc-tooling-environment/Write-EnvironmentSet.ps1.md#comment3)
    $scoped = -not $Persist

    $snapshot = [ordered]@{}
    if ($scoped) {
        foreach ($entry in $entries) {
            $snapshot[$entry.Name] = [System.Environment]::GetEnvironmentVariable($entry.Name, 'Process')
        }
    }

    try {
        foreach ($entry in $entries) {
            $display = if ($entry.Secret) {
                '***'
            }
            else {
                $entry.Value
            }
            $suffix = if ($entry.Address) {
                " (from $($entry.Address))"
            }
            else {
                ''
            }
            Write-Message "Setting environment variable: $($entry.Name) = $display$suffix"
            Set-ProcessEnvironmentVariable -Name $entry.Name -Value $entry.Value
        }

        if ($scoped) {
            & $ScriptBlock
        }
    }
    finally {
        # $null restores a previously-unset variable to unset (Set-ProcessEnvironmentVariable removes it).
        foreach ($restoreName in $snapshot.Keys) {
            Set-ProcessEnvironmentVariable -Name $restoreName -Value $snapshot[$restoreName]
        }
    }
}
