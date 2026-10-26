# pwsh/Base.GeneratedFiles/private/Get-GeneratedWriterInputFile.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

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

## comment:2

Above `$files =...`, written with `#`.

```text
Only a glob with no literal folder needs the repository root walked; every other glob walks its own folder, and a folder an
ancestor's walk already reaches is not walked twice.
```

## comment:3

Above `$files =...`, written with `#`.

```text
Only a glob with no literal folder walks the root, so a narrow writer pays only for the folders its own globs
reach.
```

## comment:4

Above `$root = [System.IO.Path]::GetFullPath($RepositoryRoot)`, written with `#`.

```text
One walk per folder lists its files and folders apart, already relative to the root, so nothing is cut per path
here.
```
