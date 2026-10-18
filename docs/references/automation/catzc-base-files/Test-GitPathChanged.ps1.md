# automation/Catzc.Base.Files/Test-GitPathChanged.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Tests whether anything under the given repository paths differs from HEAD.

### description

A thin, read-only predicate over `git status --porcelain -- <paths>`: true when git reports any modified, new, or deleted entry under the
paths, false when they match HEAD. This is the one "did these paths change?" question both the pathspec-limited committer
(Invoke-GitCommit's idempotent no-op) and its policy callers (which paths deserve a commit at all) ask, so it lives in one function instead
of two porcelain parses.

Runs through Invoke-Executable -Silent: read-only, no console output, throws on a git failure.

### parameter `Path`

The repository-relative, '/'-separated paths (files or folders) to check.

### outputs

`[bool]`

### example 1

```powershell
Test-GitPathChanged 'automation/.compiled'
```

### example 2

```powershell
Test-GitPathChanged 'automation/.compiled', 'out'
```
