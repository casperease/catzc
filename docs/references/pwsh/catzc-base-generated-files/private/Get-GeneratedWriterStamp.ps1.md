# pwsh/Catzc.Base.GeneratedFiles/private/Get-GeneratedWriterStamp.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

The stamp of a generated-file writer's inputs as they stand on disk.

### description

Hashes every file the input globs match among the walk's files (Get-InputStamp), salted with the folders a wildcard glob's leaf could be
written into. The match is one call over the whole walk (GlobPattern.MatchingPaths). With no file matched, the stamp is the hash of the salt
alone, so an empty input set still has a stable stamp.

### parameter `InputGlob`

The writer's input globs, as generated-files.yml declares them.

### parameter `Walk`

The files and folders of the shared walk (Get-GeneratedWriterInputFile), repository-relative.

### parameter `RepositoryRoot`

The root the matched files are read under.

### outputs

`[string]` The stamp, as hexadecimal.

### example 1

```powershell
Get-GeneratedWriterStamp -InputGlob 'widget/**' -Walk $walk -RepositoryRoot $root
```

## comment:1

Above `$globs = [string[]] @($InputGlob | Where-Object { $_ })`, written with `#`.

```text
The stamp of every file on disk a writer's inputs match, committed, changed or ignored alike, so a pull or a drifted ignored file
changes it as surely as an edit; salted with the folders a wildcard glob's leaf could be written into, so a new folder that should
receive a generated file makes the writer due before the file exists. The files and folders are the shared walk's.
```

## comment:2

Above `$prefix = $RepositoryRoot.TrimEnd('\', '/') +...`, written with `#`.

```text
Every matching file on disk counts, committed or ignored, so a pull or a hand-drifted file changes the stamp as
surely as an edit.
```
