# automation/Catzc.Tooling.Core/Get-ToolCommandSuffix.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its
comment sat above (Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Maps a snake_case tool key from tools.yml to its PascalCase command suffix.

### description

Tool identities in tools.yml are snake_case (e.g. 'az_cli', 'node_js', 'py_spark'),
matching the config-naming ADR. The per-tool commands, however, follow the module's
Verb-Noun convention (Install-AzCli, Remove-NodeJs, Uninstall-PySpark). This converts
the config key to that command suffix so name-based dispatch and user-facing
"Run `Install-<x>`" messages resolve correctly: 'az_cli' -> 'AzCli'.

### parameter Tool

The snake_case tool key (e.g. 'py_spark').

### example 1

```powershell
Get-ToolCommandSuffix -Tool 'az_cli'   # -> 'AzCli'
```
