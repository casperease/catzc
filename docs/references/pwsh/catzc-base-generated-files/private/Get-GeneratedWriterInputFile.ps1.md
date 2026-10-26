# pwsh/Base.GeneratedFiles/private/Get-GeneratedWriterInputFile.ps1

The private walk behind the generated-file writers' stamps: it lists the files and folders on disk that the writers' input globs can claim,
once for all of them.

## help

### synopsis

The files and folders on disk that generated-file writers' input globs can claim, from bounded walks of their literal folders.

### description

A literal glob is one existence check. A wildcard glob walks its literal folder with Get-ChildPath, as deep as its segments reach, or
input_depth of generated-files.yml for a '**' glob; only a glob with no literal folder walks the repository root. A folder that an
ancestor's walk already reaches is not walked again, and every glob of the call shares the result.

### parameter `InputGlob`

The input globs the walk must reach, of one writer or of all of them.

### parameter `RepositoryRoot`

The root the walk starts at.

### outputs

`[pscustomobject]` File and Folder, each a list of repository-relative paths.

### example 1

```powershell
Get-GeneratedWriterInputFile -InputGlob 'widget/**', 'gadget/*.yml' -RepositoryRoot $root
```

## Why the walks are bounded

Only a glob with no literal folder needs the repository root walked. Every other glob walks its own folder, so a narrow writer pays only
for the folders its globs reach, and a folder an ancestor's walk already reaches is not walked twice. One walk per folder lists its files
and folders apart, already relative to the root, so nothing is cut per path afterwards.
