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
same reference is returned on repeat calls. Inside Use-RepositoryTextSource the file is read from that source, such as a commit.

A config registered in configs/configs.yml (`<name>: { type: <C# FQN> }`) is constructed as `[type]::new($dict`), which maps and validates
it; every shipped config is registered (Test-ShippedConfigs). An unregistered config — a fixture, or one a PowerShell validator checks
through Invoke-ConfigValidator (Catzc.Base.ConfigExtensions) — is returned raw, as the ordered dictionary. See the module-config-loading
record.

In build mode, a consumer overlay may hold a fragment of the config at `<RepositoryRoot>/.catzc/pwsh/<Module>/configs/<name>.yml`. The
fragment is merged onto the bundled config before the type validates it (Merge-ConfigFragment: maps merge, scalars and lists replace, null
resets a key to its declared default), so a setting resolves caller → overlay fragment → bundled config → type default. A sealed config
(configs.yml scope: engine) refuses a fragment.

In build mode, a config registered with `scope: working-root` is read whole from `<RepositoryRoot>/.catzc/configs/<name>.yml`, never merged
onto the bundled file; when that file is absent the type's declared defaults apply. In source mode it is read as any other config.

A config's identity is its namespace and its name
([ADR-AUTO-CONSUMER-OWNCONFIGS](../../../drs/automation/consumer-repository.md#rule-adr-auto-consumer-ownconfigs)). A bare name resolves in
the namespace of the module that calls: the nearest call-stack frame holding a module named `<Namespace>.<Folder>` gives the first segment,
and a script, the console or a module with no dot in its name gives `Catzc`, so catzc's call sites keep reading catzc's configs and a
consumer module's calls read its own. -Namespace names another one. A name only the other namespace has throws, naming the namespace
searched and the one that has it, and never falls back. A consumer's config is its own file under its module in build mode: no bundle copy,
no overlay fragment and no working-root read; its type comes from the consumer's registry entry beside catzc's sealed registry.

-ListOwners loads nothing: it lists every module of the namespace that ships the config, as @{ Namespace; Name; Module; Path } sorted by
module name (ordinal), and nothing when none does. A config several modules opt into by shipping it (glossary) is read by listing its owners
and then reading each with -Module.

### parameter `Config`

The config's global lowercase name (kebab-case), without the .yml extension — e.g. 'ado', 'pipeline-env'.

### parameter `Module`

Disambiguates when the same config name exists in more than one module.

### parameter `Namespace`

The namespace the name resolves in. Without it, the namespace of the calling module, `Catzc` for a script or the console.

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

Get-Config is the one reader of every config ([ADR-CONF-LOADING-CONFIGONEREADER][r1]). The name is discovered, and an unknown one throws
([ADR-CONF-LOADING-EXISTENCEDISCOVERED](../../../drs/configuration/module-config-loading.md#rule-adr-conf-loading-existencediscovered),
[ADR-CONF-ADDRESSING-RESOLUTIONFAILSFAST](../../../drs/configuration/config-value-addressing.md#rule-adr-conf-addressing-resolutionfailsfast)).

## Caller's namespace

The caller is found by Get-CallerNamespace (see its page `private/get-caller-namespace.md`), which walks `Get-PSCallStack` from the frame
above `Get-Config` to the first frame whose command has a module name, so a script block inside a module function counts as that module. The
first segment before the dot is the namespace; no dot reads `Catzc`. A function that wraps `Get-Config` in a catzc module resolves its own
caller's namespace through Get-CallerNamespace and passes it as -Namespace, as `Get-ConfigValue` does.

## Cache

The cache is keyed by the resolved file path
([ADR-CONF-LOADING-CACHEBYPATH](../../../drs/configuration/module-config-loading.md#rule-adr-conf-loading-cachebypath)), and its entry is
probed strict-clean
([ADR-PWSH-CACHE-STRICTSAFEPROBE](../../../drs/automation/pwsh/script-scope-caching.md#rule-adr-pwsh-cache-strictsafeprobe)). In build mode
the key also carries the stamp of the consumer overlay's fragment ([ADR-AUTO-OVERLAY](../../../drs/automation/consumer-overlay.md)), so an
edited fragment is never served from a stale merge.

Inside Use-RepositoryTextSource, such as a commit that Use-WorldMapRevision loads, the shipped file and a split config's parts are read
through Read-RepositoryText and Get-RepositoryTextFile from that source, and the key carries the source's name. A commit's config and the
working tree's never share an entry. The overlay fragment is not part of the repository, so it is always read from disk.

## Typed construction

The registered C# type maps and validates the parsed dictionary at construction
([ADR-CONF-LOADING-CSHARPCONFIGTYPE](../../../drs/configuration/module-config-loading.md#rule-adr-conf-loading-csharpconfigtype)).

## Working-root read

A `working-root` config describes the repository rather than the engine, so a consumer repository gets its own, not catzc's with additions
([ADR-CONF-LOADING-WORKINGROOTREADWHOLE](../../../drs/configuration/module-config-loading.md#rule-adr-conf-loading-workingrootreadwhole)).
The scope is read from the config's registry entry, never from its name. The cache key is the working-root path with the file's stamp, and
no overlay fragment is looked up for it.

## Overlay folder

An overlay folder is named like the bundled module's folder, which drops the namespace the module's full name carries. A registered type
with no shipped file finds its folder through its loaded module.

[r1]: ../../../drs/configuration/module-config-loading.md#rule-adr-conf-loading-configonereader
