# automation/Catzc.Base.Engines/Get-ExecutionEngine.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its
comment sat above (Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Returns the repository's execution engines, or one by name.

### description

The repository's own code runs under exactly three execution engines, pwsh, bash and zsh, declared once in the
ExecutionEngines model ([ADR-AUTO-ENGINE](../../../adr/automation/execution-engines.md)): each names how its
executable is located, which scripts it runs, how it starts non-interactively, how it loads an entry script and
runs a command (StartArguments), its strict mode, its time safeguard, the line endings and executable bit its
scripts need, and its importer entry. A caller reads what differs between the engines here instead of restating
it.

### parameter Name

The engine's name (pwsh, bash or zsh). Omit for every engine, pwsh first.

### outputs

`[Catzc.Base.Engines.ExecutionEngine]`

### example 1

```powershell
(Get-ExecutionEngine -Name bash).StartArguments('importer.sh', 'get-widget')
```

### example 2

```powershell
Get-ExecutionEngine | Select-Object Name, ImporterEntry, StrictMode
```
