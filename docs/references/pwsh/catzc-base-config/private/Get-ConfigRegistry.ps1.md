# pwsh/Catzc.Base.Config/private/Get-ConfigRegistry.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Returns the config registry (this module's configs/configs.yml), keyed by config name.

### description

The registry Get-Config reads: maps each shipped config name to its C# config type (`type:`). An unregistered config loads raw. Loaded
directly here (not via Get-Config, to avoid circularity), validated by the C# type Catzc.Base.Config.ConfigsConfig (which the registry
registers for its own 'configs' config), and cached for the session. The file is located through Get-CatzcModuleRoot, so the shipped
registry resolves inside the loaded module in both run modes
([ADR-AUTO-ASSETDEP-INTERNALASSETDEPENDENCY](../../../../adr/automation/internal-asset-dependencies.md#rule-adr-auto-assetdep-internalassetdependency)).

## comment:1

Above `$cached =...`, written with `#`.

```text
strict-clean
([ADR-PWSH-CACHE-STRICTSAFEPROBE](/docs/adr/automation/pwsh/script-scope-caching.md#rule-adr-pwsh-cache-strictsafeprobe))
```
