# pwsh/Base.Config/private/Get-ConfigRegistry.ps1

The private loader of the config registry, `configs/configs.yml`, validated by its own C# type and cached for the session.

## help

### synopsis

Returns the config registry (this module's configs/configs.yml), keyed by config name.

### description

The registry Get-Config reads: maps each shipped config name to its C# config type (`type:`). An unregistered config loads raw. Loaded
directly here (not via Get-Config, to avoid circularity), validated by the C# type Catzc.Base.Config.ConfigsConfig (which the registry
registers for its own 'configs' config), and cached for the session. The file is located through Get-CatzcModuleRoot, so the shipped
registry resolves inside the loaded module in both run modes
([ADR-AUTO-ASSETDEP-INTERNALASSETDEPENDENCY](../../../../drs/automation/internal-asset-dependencies.md#rule-adr-auto-assetdep-internalassetdependency)).

## Cache probe

The cache entry is probed strict-clean
([ADR-PWSH-CACHE-STRICTSAFEPROBE](../../../../drs/automation/pwsh/script-scope-caching.md#rule-adr-pwsh-cache-strictsafeprobe)).
