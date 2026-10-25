# pwsh/Catzc.Base.QualityGates/Save-GeneratedWriterStamp.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Stores a generated-file writer's input stamp after it has run, so it is not due again until one of its inputs changes.

### description

The stamp is taken after the run, over every file on disk the writer's declared inputs match, so a target the writer declares as an input
and has just written is part of it. The import janitor calls it after each writer it ran, and Build-RootConfig after a whole run.

### parameter `Name`

The writer, as generated-files.yml names it. A name the file does not declare throws.

### parameter `RepositoryRoot`

The root the writer's inputs are walked under. Default: the repository root.

### parameter `MemoPath`

The memo the stamp is stored in, beside the other writers' stamps. Default: out/cache/generated-writers.json.

### example 1

```powershell
Save-GeneratedWriterStamp -Name Build-RootConfig
```

## comment:1

Above `$writer = (Get-Config -Config generated-files).writers[$Name]`, written with `#`.

```text
Stores a writer's input stamp once it has run, taken after the run, so an input it writes itself (a target declared as an input) is
part of the stored stamp and the writer is not due again until one of its inputs changes.
```
