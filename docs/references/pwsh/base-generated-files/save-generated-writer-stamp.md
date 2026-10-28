# pwsh/Base.GeneratedFiles/Save-GeneratedWriterStamp.ps1

The command that records a generated-file writer's input stamp in the memo after the writer has run. `Get-GeneratedWriterDue` compares the
stored stamp with the current one.

## help

### synopsis

Stores a generated-file writer's input stamp after it has run, so it is not due again until one of its inputs changes.

### description

The stamp is taken after the run, over every file on disk the writer's declared inputs match, so a target the writer declares as an input
and has just written is part of it. The import janitor calls it after each writer it ran, and Build-RootConfig after a whole run.

### parameter `Name`

The writer, as a writer row of a module's `generated.yml` names it. A name no row declares throws.

### parameter `RepositoryRoot`

The root the writer's inputs are walked under. Default: the repository root.

### parameter `MemoPath`

The memo the stamp is stored in, beside the other writers' stamps. Default: out/cache/generated-writers.json.

### example 1

```powershell
Save-GeneratedWriterStamp -Name Build-RootConfig
```

## Why the stamp is taken after the run

The stamp is taken after the run, so an input the writer writes itself (a target declared as an input) is part of the stored stamp. A file
the writer both reads and writes then never makes it due again by itself; it is due again only when one of its inputs changes.
