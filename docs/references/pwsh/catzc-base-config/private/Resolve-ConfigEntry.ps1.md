# automation/pwsh/Catzc.Base.Config/private/Resolve-ConfigEntry.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Resolves a config name to its owning module and file path (the discovery seam).

### description

Scans `<module>/configs/*.yml` under the loaded code root (Get-CatzcModulesRoot — the source tree's automation/ or a built package) once
(cached) into a name -> entries index, and resolves a requested name to a single @{ Name; Module; Path }. -Module disambiguates a name
present in more than one module. In build mode the scan also covers a consumer overlay's local modules — the folders under
.catzc/automation/ that name no bundled module ([ADR-AUTO-OVERLAY](../../../../adr/automation/consumer-overlay.md)) — so a local module's
configs are found like any module's. Throws when the name is unknown or ambiguous. -All instead returns every entry of the name, one per
owning module sorted by module name (ordinal), and nothing when no module has it — the listing for a config several modules opt into by
shipping it. Mock this to redirect a config to a fixture in logic tests (see ADR test-automation).

### parameter `Config`

The config name (without the .yml extension).

### parameter `Module`

Disambiguates a name present in multiple modules.

### parameter `All`

Returns every module's entry for the name instead of resolving a single one.

## comment:1

Above `$script:configIndex = @{}`, written with `#`.

```text
strict-clean probe of the lazy cache entry
([ADR-PWSH-CACHE-STRICTSAFEPROBE](/docs/adr/automation/pwsh/script-scope-caching.md#rule-adr-pwsh-cache-strictsafeprobe))
```

## comment:2

Above `$registry = Get-ConfigRegistry`, written with `#`.

```text
A registered type with no shipped file is a config too: its type's namespace names the module, and it builds from {} plus the
repository's fragment, so every key takes the default the type declares.
```
