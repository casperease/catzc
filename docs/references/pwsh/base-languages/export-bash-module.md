# pwsh/Base.Languages/Export-BashModule.ps1

The exporter that packages a bash module's tracked source into a build folder and records which files are executable.

## help

### synopsis

Packages a bash module into a destination folder, with an executables.json that lists its executable files.

### description

Copies the files git tracks for the module, tests excluded, in ordinal order, and sets the executable mode on the listed executables on a
POSIX host. Writes `executables.json`, a sorted list with one path per line, from which the installer restores the executable bit on a POSIX
host. Returns the module, destination, file count and executable count.

### parameter `Module`

The module folder, relative to the repository root or an absolute path under it.

### parameter `Destination`

The folder the module is packaged into; created when missing.

### parameter `Silent`

Suppresses the message that names the packaged module.

### example 1

```powershell
Export-BashModule -Module 'bash/widget' -Destination $buildRoot/bash/widget
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
