# pwsh/Base.QualityGates/Format-FileMeta.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Brings the head of every in-scope file to its head policy: the body hash and the edges of a navigation head, the authored config part alone,
or no head.

### description

The output is byte-identical on every run, so a second run changes no file. The imprinted parts are wholly the engine's, so a key no meta
kind owns there is dropped; the authored `config` part is kept as written, and a file whose block holds a section that is neither is
reported and left unchanged.

It announces how many files it checks before it checks them. It shares Format-Code's result cache for the file-meta imprint step, keyed on
each file's SHA-256 and a stamp of the step's settings files, so a file either command last found clean is not checked again
([ADR-AUTO-CACHE](../../../drs/automation/caching.md)). A file the run would change, or one a person must decide by hand, is never recorded
as clean. -NoCache checks every file.

It rests on [ADR-REPO-FILEMETA-IMPRINTEDPARTS](../../../drs/repository/file-meta.md#rule-adr-repo-filemeta-imprintedparts) and
[ADR-REPO-FORMAT-METAIMPRINT](../../../drs/repository/uniform-formatting.md#rule-adr-repo-format-metaimprint).

### parameter `Path`

Files or folders to format. Default: every in-scope file.

### parameter `RepositoryRoot`

The repository root paths are relative to. Default: the loaded repository root.

### parameter `DryRun`

Report what would change without writing any file.

### parameter `NoCache`

Check every file, ignoring the result cache (which is still refreshed).

### parameter `PassThru`

Return a result object ({ ChangedCount; ChangedFiles; FileCount; DryRun }) instead of only the changed paths.

### outputs

`[string[]]` the repository-relative paths changed (or, under -DryRun, that would change); with -PassThru, the result object.

### example 1

```powershell
Format-FileMeta
```

### example 2

```powershell
Format-FileMeta -DryRun -PassThru
```

### example 3

```powershell
Format-FileMeta -Path docs/references
```

## comment:1

Above `function Format-FileMeta {`, written with `#`.

```text
The repository's preview switch is -DryRun, so ShouldProcess and -WhatIf are deliberately absent.
[ADR-AUTO-DRYRUN-BRANCHBEFORESIDEEFFECT](/docs/drs/automation/dry-run.md#rule-adr-auto-dryrun-branchbeforesideeffect)
```

## comment:2

Above `$stamp = Get-FormatEngineStamp -Engine 'imprint:file-meta' -Settings...`, written with `#`.

```text
The cache is Format-Code's own for its file-meta step: one verdict, one cache, so either command skips what the other found clean.
A head also reads the files beside its own (the comment page, the relations' candidates), so each file's key carries their stamp too.
```

## comment:3

Above `$unfixable = @($saved.Unowned | ForEach-Object {...`, written with `#`.

```text
A file a person must still repair, or one the run would change, is never recorded as clean, so the next run
reports it again.
```
