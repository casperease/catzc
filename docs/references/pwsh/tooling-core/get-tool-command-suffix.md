# pwsh/Tooling.Core/Get-ToolCommandSuffix.ps1

The converter from a snake_case tool key of `tools.yml` to the PascalCase suffix of the tool's per-tool commands, so name-based dispatch and
the "Run `Install-<x>`" messages resolve.

## help

### synopsis

Maps a snake_case tool key from tools.yml to its PascalCase command suffix.

### description

Tool identities in tools.yml are snake_case (e.g. 'az_cli', 'node_js', 'py_spark'), matching the config-naming record. The per-tool
commands, however, follow the module's Verb-Noun convention (Install-AzCli, Remove-NodeJs, Uninstall-PySpark). This converts the config key
to that command suffix so name-based dispatch and user-facing "Run `Install-<x>`" messages resolve correctly: 'az_cli' -> 'AzCli'.

### parameter `Tool`

The snake_case tool key (e.g. 'py_spark').

### example 1

```powershell
Get-ToolCommandSuffix -Tool 'az_cli'   # -> 'AzCli'
```
