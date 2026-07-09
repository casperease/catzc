<#
.SYNOPSIS
    Prepares a set of $env: variables for a child or external process to read — the one sanctioned seam for
    handing a secret to an external consumer through the environment (ADR environment-variables, ADR-AUTO-ENVVAR:7).
.DESCRIPTION
    Writes environment variables for an external/child/test process from three distinct, unambiguous channels,
    so intent is never guessed (poka-yoke):

      -Set   a map whose value is either a [SecureString] (a SECRET) or a 'global.<config>...' config address
             (a non-secret value or subtree, resolved by Get-ConfigValue — ADR config-value-addressing). The
             map KEY is the environment variable name (for a secret or a scalar address) or the prefix (for a
             subtree address). A bare literal string in -Set is REJECTED — pass it through -Value instead, so a
             literal can never be mistaken for a secret or an address.
      -Value a map of explicit non-secret literals (key = env name, value = literal string).

    Secrets are taken as [SecureString], never logged or returned (masked ***), and decrypted to plaintext only
    at the $env: assignment. A subtree address flattens under its prefix, env-normalized: uppercased, '.'->'_'
    and '[n]'->'_n' (so prefix 'DB' + 'options.ssl' -> DB_OPTIONS_SSL). If two channels would produce the same
    env var name, the call throws rather than silently letting one win.

    Lifetime is one of two mutually exclusive parameter sets:
      -ScriptBlock  (Scoped, the default): snapshot each target's current value, set all, invoke the block, and
                    restore every target in a finally (previously-unset variables are removed) — the secret
                    leaves the environment when the block exits. The block's output is returned.
      -Persist:     set all and leave them for the rest of the session/child; nothing is returned.

    Cross-platform note (ADR cross-platform): [SecureString] is DPAPI-encrypted only on Windows; on Linux/macOS
    .NET stores it obfuscated, not encrypted. The value of the contract here is don't-log / don't-internalize /
    decrypt-only-at-the-boundary, not at-rest cryptography — the plaintext necessarily lands in $env: for the
    instant the external tool reads it (ADR-AUTO-ENVVAR:7).
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

    # 1) Resolve every channel into a flat list of env-var assignments. Each entry:
    #    @{ Name; Value; Secret; Origin; Address }  (Address is $null unless address-sourced).
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

    # 3) Apply. Scoped snapshots each target's current value, sets all, invokes the block, and restores in a
    #    finally; Persist just sets all and leaves them. Both share one set+log loop.
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
