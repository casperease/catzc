# pwsh/Base.Languages/Export-PythonModule.ps1

The exporter that packages a python module's tracked source, and the wheels its lock file pins, into a build folder.

## help

### synopsis

Packages a python module into a destination folder, with its locked wheels and a wheels.json when it holds a uv.lock.

### description

Copies the files git tracks for the module, tests excluded, in ordinal order. When the module holds a `uv.lock`, the managed uv exports the
locked requirements and downloads each wheel from the managed cache into `wheels/`, offline, so no feed is contacted; a missing or unpinned
uv, or a wheel absent from the cache, throws. Writes `wheels.json`, the sorted wheel names with their SHA-256. Returns the module,
destination, file count and wheel count.

### parameter `Module`

The module folder, relative to the repository root or an absolute path under it.

### parameter `Destination`

The folder the module is packaged into; created when missing.

### parameter `Silent`

Suppresses the message that names the packaged module.

### example 1

```powershell
Export-PythonModule -Module 'python/widget' -Destination $buildRoot/python/widget
```

## comment:1

Above `$files = [System.Collections.Generic.List[string]]::new()`, written with `#`.

```text
Only what git tracks ships, and no test
([ADR-AUTO-BUNDLE-EVERYLANGUAGE](/docs/drs/automation/platform-bundle.md#rule-adr-auto-bundle-everylanguage)).
```

## comment:2

Above `$files.Sort([System.StringComparer]::Ordinal)`, written with `#`.

```text
Sorted ordinally, so a rebuild writes the same bytes
([ADR-AUTO-BUNDLE-IMMUTABLEBUILD](/docs/drs/automation/platform-bundle.md#rule-adr-auto-bundle-immutablebuild)).
```

## comment:3

Above `$saved = [System.Environment]::GetEnvironmentVariable('UV_OFFLINE')`, written with `#`.

```text
Every call is offline: the wheels come from the managed cache, never from a feed
([ADR-AUTO-NET](/docs/drs/automation/network-calls.md)).
```

## comment:4

Above `$wheels = [System.Collections.Generic.List[string]]::new()`, written with `#`.

```text
The sorted names with their SHA-256, so a rebuild compares byte for byte
([ADR-AUTO-BUNDLE-IMMUTABLEBUILD](/docs/drs/automation/platform-bundle.md#rule-adr-auto-bundle-immutablebuild)).
```
