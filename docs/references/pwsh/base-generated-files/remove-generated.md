# pwsh/Base.GeneratedFiles/Remove-Generated.ps1

The command that rolls the generated files off a working copy: it deletes the files of every `rollable` writer and leaves every other class
where it is, so git shows the deletions and `Restore-Generated` renders them back.

## help

### synopsis

Deletes the rollable generated files from the working copy.

### description

Reads the generated targets of the writer registry (`Get-GeneratedTarget`) and keeps those of class `rollable`. A target that names a file
without a wildcard is deleted when the file exists; a wildcard target is matched against the files below its literal folder, as deep as
`GeneratedWriterGraph.InputDepth` for a `**`, and every file it takes is deleted. Which files are generated comes from the registry alone,
never from a head a file carries (ADR-REPO-FILEMETA-NOREADBACK), so a file with a head on no declared path is authored and stays. The
`import-critical`, `snapshot` and `untracked` classes are never rolled off. With `-WhatIf` the command lists the files and deletes none.

### parameter `RepositoryRoot`

The root the targets are resolved against. Default: the repository root.

### outputs

`[string[]]` The repository-relative path of each file deleted, in ordinal order.

### example 1

```powershell
Remove-Generated -WhatIf
```

## Why only the rollable class

A session that restores the tree must import first, so the importer, the root configs, the track-sets and the module manifests
(`import-critical`) are never deleted, and a `snapshot` writer reads outside the tree and cannot be re-run from it.
