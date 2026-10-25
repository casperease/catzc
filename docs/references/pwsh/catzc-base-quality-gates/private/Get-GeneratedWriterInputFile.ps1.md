# pwsh/Catzc.Base.QualityGates/private/Get-GeneratedWriterInputFile.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

The files and folders on disk that generated-file writers' input globs can claim, from one bounded walk.

### description

Walks the repository once with Get-ChildPath, as deep as the deepest glob reaches: a glob's segment count, or for a '**' glob its literal
folder's depth plus input_depth of generated-files.yml. Every writer's globs share the result, so the walk is paid once per call.

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

## comment:1

Above `$depth = 1`, written with `#`.

```text
The repository-relative files and folders on disk the input globs can claim, from one bounded walk of the repository as deep as the
deepest glob reaches ('**' reaches input_depth below its literal folder), shared by every writer's globs.
```
