# automation/Catzc.Base.QualityGates/Sync-FileMeta.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Brings one file up to date with the meta head its head policy says it has, formatted as Format-Code leaves it.

### description

A one-shot for the file at hand, after an edit, a move or a rename: it formats the file with its language's formatter and imprint steps
(Format-Code, cache off), then imprints, replaces or strips its meta block as the head policy of its class says (Format-FileMeta), so a file
whose language has no formatter is brought up to date too. A file git does not track yet is taken as given; a file git ignores is left
alone. The facts come from the registries, git, the disk and the file's text, never from its head
([ADR-REPO-FILEMETA#14](../../../adr/repository/file-meta.md#rule-adr-repo-filemeta14)).

It loads the registries on every call, so it is no loop primitive: a loop asks an Assert- or Test- guard the one question it needs. It
writes and never judges; Test-FileMeta and Test-Formatting give the verdict.

### parameter `Path`

The one file to bring up to date, absolute or relative to the current folder, inside the repository.

### parameter `DryRun`

Report what would change without writing the file.

### parameter `PassThru`

Return a result object ({ Path; Changed; Unfixable; DryRun }) instead of only the changed path.

### outputs

`[string]` the repository-relative path when the file changed (or, under -DryRun, would change); with -PassThru, the result object.

### example 1

```powershell
Sync-FileMeta docs/explanation/file-meta.md
```

### example 2

```powershell
Sync-FileMeta automation/Catzc.Widget/Get-Widget.ps1 -DryRun -PassThru
```
