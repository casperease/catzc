# pwsh/Base.GeneratedFiles/Assert-GeneratedStaysCommitted.ps1

The commit guard that refuses a staged deletion of a generated file the `generated` view says stays committed. It reads the writer rows of
every module's `generated.yml`, through `Get-GeneratedWriterOrder`, and never a file's head.

## help

### synopsis

Refuses staged deletions of generated files whose writer is not rollable.

### description

A staged deletion is refused when a writer whose class is `import-critical`, `snapshot` or `untracked` declares the path as an output, a
wildcard output matching it too. A rollable writer's output may be deleted (Remove-Generated deletes exactly those), and a path no writer
declares is authored, so it passes. The throw names each refused path with its writer and class.

### parameter `Path`

The repository-relative deleted paths to judge. Default: the paths `git diff --cached --diff-filter=D` lists.

### example 1

```powershell
Assert-GeneratedStaysCommitted
```

## Why the registry and not the head

A head is a one-way note to a person and may be out of sync, so no command decides from it (ADR-REPO-FILEMETA-NOREADBACK). The registry rows
are the one truth of which files are generated and of which stay committed.
