# pwsh/Catzc.Base.QualityGates/Format-FileMeta.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Imprints the place facts and the edges into the meta block of every in-scope Markdown file.

### description

The output is byte-identical on every run, so a second run changes no file. The authored `config` part is kept as written, and a file whose
block holds a key no meta kind owns is reported and left unchanged.

It rests on [ADR-REPO-FILEMETA-IMPRINTEDPARTS](../../../adr/repository/file-meta.md#rule-adr-repo-filemeta-imprintedparts) and
[ADR-REPO-FORMAT-METAIMPRINT](../../../adr/repository/uniform-formatting.md#rule-adr-repo-format-metaimprint).

### parameter `Path`

Files or folders to format. Default: every in-scope file.

### parameter `RepositoryRoot`

The repository root paths are relative to. Default: the loaded repository root.

### parameter `DryRun`

Report what would change without writing any file.

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
[ADR-AUTO-DRYRUN-BRANCHBEFORESIDEEFFECT](/docs/adr/automation/dry-run.md#rule-adr-auto-dryrun-branchbeforesideeffect)
```
