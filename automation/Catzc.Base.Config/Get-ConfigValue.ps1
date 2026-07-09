<#
.SYNOPSIS
    Resolves a global config address to the value at that node (a leaf or a subtree).
.DESCRIPTION
    A global config address is a by-reference handle into a named config: global.<config>.<key>[.<key>...]
    (see ADR config-value-addressing, code addr). Get-ConfigValue strips the 'global.' marker, reads the named
    config through Get-Config (the one reader and one cache, ADR-CONF-LOADING:1), and walks the remaining key segments with
    Resolve-ConfigKeyPath. It never opens a file or caches anything of its own — it is a view over what
    Get-Config already loaded and validated.

    The first segment after 'global.' is the config's global lowercase name (ADR-CONF-LOADING:2); the owner module is
    discovered, not part of the address. The remaining segments (which may be empty, addressing the whole
    config) are walked into the parsed config. An unknown/ambiguous name or an unresolvable key throws
    (ADR-CONF-ADDRESSING:4) — there is no silent $null. The returned node may be a live reference into the config cache and
    must be treated as read-only (ADR-CONF-ADDRESSING:5). Addresses only ever reach version-controlled config, so nothing
    addressable is a secret (ADR-CONF-ADDRESSING:3); secrets travel out-of-band as [SecureString] (see ADR
    environment-variables, ADR-AUTO-ENVVAR:7).
.PARAMETER Address
    The global config address: global.<config>.<key>[.<key>...] — e.g. 'global.myproperty.name'. The key path
    is optional; 'global.<config>' addresses the whole config as a subtree.
.PARAMETER Module
    Passthrough to Get-Config to disambiguate the rare config name present in more than one module.
.EXAMPLE
    Get-ConfigValue -Address 'global.myproperty.name'
    # the leaf value at the 'name' key of the 'myproperty' config
.EXAMPLE
    Get-ConfigValue -Address 'global.database'
    # the whole 'database' config as a subtree
#>
function Get-ConfigValue {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [ValidatePattern('(?-i)^global\.[a-z0-9]+(-[a-z0-9]+)*(\.[^.]+)*$')]
        [string] $Address,

        [string] $Module
    )

    $parts = $Address -split '\.'
    $configName = $parts[1]
    $keyPath = [string[]]@()
    if ($parts.Count -gt 2) {
        $keyPath = $parts[2..($parts.Count - 1)]
    }

    $config = Get-Config -Config $configName -Module $Module
    Resolve-ConfigKeyPath -Node $config -Segment $keyPath -Address $Address
}
