# pwsh/Base.GeneratedFiles/private/Get-GeneratedWriterStamp.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

The stamps of generated-file writers' inputs as they stand on disk, one per writer.

### description

For each writer, hashes every file its input globs match among the walk's files, salted with the folders a wildcard glob's leaf could be
written into. The match is one call over the whole walk (GlobPattern.MatchingPaths), and one InputStamp.ComputeMany call stamps every writer
with a matched file, so a file several writers read is read once for all of them. A writer with no file matched gets the hash of its salt
alone, so an empty input set still has a stable stamp.

### parameter `Writer`

The writer entries, as generated-files.yml declares them: each with its `name` and its `inputs` globs.

### parameter `Walk`

The files and folders of the shared walk (Get-GeneratedWriterInputFile), repository-relative.

### parameter `RepositoryRoot`

The root the matched files are read under.

### outputs

`[hashtable]` Each writer's name to its stamp, as hexadecimal.

### example 1

```powershell
Get-GeneratedWriterStamp -Writer @(@{ name = 'widget'; inputs = @('widget/**') }) -Walk $walk -RepositoryRoot $root
```

## comment:1

Above `$globs = [string[]] @($entry.inputs | Where-Object { $_ })`, written with `#`.

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
