# pwsh/Catzc.Base.Files/Get-RepoStatus.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Returns where a file stands in git: unset, edited, staged, ready, committed or pushed.

### description

The states of the repository status that only git knows, computed on demand and never written into the file, since the write would change
them ([ADR-REPO-FILEMETA-FILEISNODE](../../../adr/repository/file-meta.md#rule-adr-repo-filemeta-fileisnode)). `unset`: git does not track the file.
`edited`: the working tree differs from the index. `staged`: the index differs from HEAD and the working tree matches the index.
`committed`: tracked, unchanged, and a commit that touched it is not on the upstream branch. `pushed`: tracked, unchanged and every commit
that touched it is on the upstream. `ready`: tracked and unchanged on a branch with no upstream, so nothing says whether the server has it.

The answer is git's alone. The file's own stored `repo_status` (`locked` or `clean`) is in its head, which a module above this one reads, so
a caller that wants both reads the head too; the two never share a value.

Read-only: one `git status`, and for an unchanged tracked file one `git branch --show-current`, one `git for-each-ref` and one `git log`,
each from the repository root.

### parameter `Path`

The repository-relative, '/'-separated path of the file.

### outputs

`[string]` unset, edited, staged, ready, committed or pushed.

### example 1

```powershell
Get-RepoStatus 'docs/adr/repository/file-meta.md'
```
