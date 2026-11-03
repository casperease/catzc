# pwsh/Base.Languages/private/Get-ModuleShippedFile.ps1

The one list of the files a language exporter ships for a module: what git tracks under it, without its tests.

## help

### synopsis

Returns the module-relative paths of the tracked files a module ships.

### description

Takes the paths git tracks under the module and drops every path under the test folder the languages layout names by role, so no test of any
language ships. With -ExecutableOnly it lists only the tracked files that carry the executable mode. The paths are relative to the module
and forward-slashed.

### parameter `Module`

The module folder, relative to the repository root.

### parameter `ExecutableOnly`

Lists only the tracked files with the executable mode.

### outputs

`[string[]]` The module-relative paths.

### example 1

```powershell
Get-ModuleShippedFile 'bash/widget' -ExecutableOnly
```

## comment:1

Above `$testPrefix = "$((Get-Config -Config languages).FolderOf('test'))/"`, written with `#`.

```text
The module's test folder is the one the layout names by role; no test of any language ships
([ADR-AUTO-BUNDLE-EVERYLANGUAGE](/docs/drs/automation/platform-bundle.md#rule-adr-auto-bundle-everylanguage)).
```
