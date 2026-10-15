# docs/references/automation/catzc-base-files/Test-GitPathChanged.ps1.md

`automation/Catzc.Base.Files/Test-GitPathChanged.ps1`

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
A thin, read-only predicate over `git status --porcelain -- <paths>`: true when git reports any
modified, new, or deleted entry under the paths, false when they match HEAD. This is the one
"did these paths change?" question both the pathspec-limited committer (Invoke-GitCommit's
idempotent no-op) and its policy callers (which paths deserve a commit at all) ask, so it lives
in one function instead of two porcelain parses.

Runs through Invoke-Executable -Silent: read-only, no console output, throws on a git failure.
```
