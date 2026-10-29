# pwsh/Base.QualityGates/private/Get-TestRunEntryLine.ps1

Builds the one line that starts the engine in a test worker: the repository importer, or the build's Import-Catzc.ps1 with its parameters.

## help

### synopsis

Returns the line that loads the engine in a test worker's script.

### description

A test worker or prewarm script begins with one line that dot-sources the engine entry. A run against the source dot-sources the repository
importer with `-SkipJanitors`; a run against a build dot-sources the build's entry script and passes the entry parameters, each as a quoted
value and a boolean as a bare switch only when true, in name order, so the line is the same for the same run.

### parameter `EntryScript`

The engine entry of a build run (the build's Import-Catzc.ps1); empty for the source run.

### parameter `EntryParameter`

The parameters handed to the entry script, by name; a false boolean is left out.

### outputs

`[string]`, the dot-sourcing line.

### example 1

```powershell
$entryLine = Get-TestRunEntryLine -EntryScript $EntryScript -EntryParameter $EntryParameter
```
