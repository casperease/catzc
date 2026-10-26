# pwsh/Base.Config/Get-Config.ps1

The one reader of every module's internal config: it discovers the config by its global name, merges a consumer overlay fragment in build
mode, validates through the registered C# type and caches the result for the session.

## help

### synopsis

Loads, validates, and caches a module's config by its global lowercase name.

### description

The single reader for any module's internal config (`configs/<name>.yml`). Existence is discovered by scanning `<module>/configs/` under the
loaded code root, Get-CatzcModulesRoot (cached, via Resolve-ConfigEntry); -Module disambiguates the rare case of the same config name in two
modules. The parsed config (ConvertFrom-Yaml -Ordered) is cached per resolved path for the session (re-run the importer to clear) and the
same reference is returned on repeat calls.

A config registered in configs/configs.yml (`<name>: { type: <C# FQN> }`) is constructed as `[type]::new($dict`), which maps and validates
it; every shipped config is registered (Test-ShippedConfigs). An unregistered config — a fixture, or one a PowerShell validator checks
through Invoke-ConfigValidator (Catzc.Base.ConfigExtensions) — is returned raw, as the ordered dictionary. See ADR module-config-loading.

In build mode, a consumer overlay may hold a fragment of the config at `<RepositoryRoot>/.catzc/pwsh/<Module>/configs/<name>.yml`. The
fragment is merged onto the bundled config before the type validates it (Merge-ConfigFragment: maps merge, scalars and lists replace, null
resets a key to its declared default), so a setting resolves caller → overlay fragment → bundled config → type default. A sealed config
(configs.yml overridable: false) refuses a fragment.

-ListOwners loads nothing: it lists every module that ships the config, as @{ Name; Module; Path } sorted by module name (ordinal), and
nothing when none does. A config several modules opt into by shipping it (glossary) is read by listing its owners and then reading each with
-Module.

### parameter `Config`

The config's global lowercase name (kebab-case), without the .yml extension — e.g. 'ado', 'pipeline-env'.

### parameter `Module`

Disambiguates when the same config name exists in more than one module.

### parameter `ListOwners`

Lists the owning modules' entries instead of loading the config.

### example 1

```powershell
(Get-Config -Config ado).organization
```

### example 2

```powershell
Get-Config -Config tools
```

### example 3

```powershell
Get-Config -Config glossary -ListOwners | ForEach-Object { Get-Config -Config glossary -Module $_.Module }
```

## One reader, discovered names

Get-Config is the one reader of every config
([ADR-CONF-LOADING-ONEREADER](../../../drs/configuration/module-config-loading.md#rule-adr-conf-loading-onereader)). The name is discovered,
and an unknown one throws
([ADR-CONF-LOADING-EXISTENCEDISCOVERED](../../../drs/configuration/module-config-loading.md#rule-adr-conf-loading-existencediscovered),
[ADR-CONF-ADDRESSING-RESOLUTIONFAILSFAST](../../../drs/configuration/config-value-addressing.md#rule-adr-conf-addressing-resolutionfailsfast)).

## Cache

The cache is keyed by the resolved file path
([ADR-CONF-LOADING-CACHEBYPATH](../../../drs/configuration/module-config-loading.md#rule-adr-conf-loading-cachebypath)), and its entry is
probed strict-clean
([ADR-PWSH-CACHE-STRICTSAFEPROBE](../../../drs/automation/pwsh/script-scope-caching.md#rule-adr-pwsh-cache-strictsafeprobe)). In build mode
the key also carries the stamp of the consumer overlay's fragment
([ADR-AUTO-OVERLAY](../../../drs/automation/consumer-overlay.md)), so an edited fragment is never served from a stale merge.

## Typed construction

The registered C# type maps and validates the parsed dictionary at construction
([ADR-CONF-LOADING-CSHARPCONFIGTYPE](../../../drs/configuration/module-config-loading.md#rule-adr-conf-loading-csharpconfigtype)).

## Overlay folder

An overlay folder is named like the bundled module's folder, which drops the namespace the module's full name carries. A registered type with
no shipped file finds its folder through its loaded module.
