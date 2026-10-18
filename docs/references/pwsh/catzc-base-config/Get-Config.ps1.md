# pwsh/Catzc.Base.Config/Get-Config.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

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

In build mode, a consumer overlay may hold a fragment of the config at `<RepositoryRoot>/.catzc/automation/<Module>/configs/<name>.yml`. The
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

## comment:1

Above `$fragmentPath = $null`, written with `#`.

```text
A consumer overlay's fragment of this config (<overlay root>/<Module>/configs/<name>.yml), in build mode only
([ADR-AUTO-OVERLAY](/docs/adr/automation/consumer-overlay.md)). The cache key carries the fragment's stamp,
so an edited fragment is never served from a stale merge.
```

## comment:2

Above `$script:configCache = @{}`, written with `#`.

```text
strict-clean probe of the lazy cache entry
([ADR-PWSH-CACHE#4](/docs/adr/pwsh/script-scope-caching.md#rule-adr-pwsh-cache4))
```
