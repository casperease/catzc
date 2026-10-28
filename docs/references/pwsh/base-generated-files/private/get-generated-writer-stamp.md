# pwsh/Base.GeneratedFiles/private/Get-GeneratedWriterStamp.ps1

The private function that computes each generated-file writer's current input stamp from the shared walk, in one batched call.

## help

### synopsis

The stamps of generated-file writers' inputs as they stand on disk, one per writer.

### description

For each writer, hashes every file its input globs match among the walk's files, salted with the folders a wildcard glob's leaf could be
written into. The match is one call over the whole walk (GlobPattern.MatchingPaths), and one InputStamp.ComputeMany call stamps every writer
with a matched file, so a file several writers read is read once for all of them. A writer with no file matched gets the hash of its salt
alone, so an empty input set still has a stable stamp.

### parameter `Writer`

The writer rows, as the `generated.yml` files declare them: each with its `name`, its `inputs` globs and the `inputs` of each of its
outputs.

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

## What the stamp covers

The stamp covers every file on disk a writer's inputs match, committed, changed or ignored alike, so a pull or a hand-drifted ignored file
changes it as surely as an edit. It is salted with the folders a wildcard glob's leaf could be written into, so a new folder that should
receive a generated file makes the writer due before the file exists. The files and folders are the shared walk's.
