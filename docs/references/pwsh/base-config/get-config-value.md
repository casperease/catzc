# pwsh/Base.Config/Get-ConfigValue.ps1

The resolver of a global config address, `global.<config>.<key>...`, to the node it names, as a view over what Get-Config already loaded.

## help

### synopsis

Resolves a global config address to the value at that node (a leaf or a subtree).

### description

A global config address is a by-reference handle into a named config: `global.<config>.<key>[.<key>...]` (see ADR-CONF-ADDRESSING).
Get-ConfigValue strips the 'global.' marker, reads the named config through Get-Config (the one reader and one cache,
[ADR-CONF-LOADING-ONEREADER](../../../drs/configuration/module-config-loading.md#rule-adr-conf-loading-onereader)), and walks the remaining
key segments with Resolve-ConfigKeyPath. It never opens a file or caches anything of its own — it is a view over what Get-Config already
loaded and validated.

The first segment after 'global.' is the config's global lowercase name
([ADR-CONF-LOADING-EXISTENCEDISCOVERED](../../../drs/configuration/module-config-loading.md#rule-adr-conf-loading-existencediscovered)); the
owner module is discovered, not part of the address. The remaining segments (which may be empty, addressing the whole config) are walked
into the parsed config. An unknown/ambiguous name or an unresolvable key throws
([ADR-CONF-ADDRESSING-RESOLUTIONFAILSFAST](../../../drs/configuration/config-value-addressing.md#rule-adr-conf-addressing-resolutionfailsfast))
— there is no silent $null. The returned node may be a live reference into the config cache and must be treated as read-only
([ADR-CONF-ADDRESSING-RESOLVEDNODEISREAD](../../../drs/configuration/config-value-addressing.md#rule-adr-conf-addressing-resolvednodeisread)).
Addresses only ever reach version-controlled config, so nothing addressable is a secret
([ADR-CONF-ADDRESSING-VERSIONCONTROLLEDONLY](../../../drs/configuration/config-value-addressing.md#rule-adr-conf-addressing-versioncontrolledonly));
secrets travel out-of-band as `[SecureString]` (see ADR environment-variables,
[ADR-AUTO-ENVVAR-SECRETTOCHILDPROCESS](../../../drs/automation/environment-variables.md#rule-adr-auto-envvar-secrettochildprocess)).

### parameter `Address`

The global config address: `global.<config>.<key>[.<key>...]` — e.g. 'global.myproperty.name'. The key path is optional; '`global.<config>`'
addresses the whole config as a subtree.

### parameter `Module`

Passthrough to Get-Config to disambiguate the rare config name present in more than one module.

### example 1

```powershell
Get-ConfigValue -Address 'global.myproperty.name'
# the leaf value at the 'name' key of the 'myproperty' config
```

### example 2

```powershell
Get-ConfigValue -Address 'global.database'
# the whole 'database' config as a subtree
```
