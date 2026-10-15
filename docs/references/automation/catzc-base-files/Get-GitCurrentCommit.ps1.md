# docs/references/automation/catzc-base-files/Get-GitCurrentCommit.ps1.md

`automation/Catzc.Base.Files/Get-GitCurrentCommit.ps1`

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The commit HEAD names in the checkout at Get-RepositoryRoot, read from its ref files in-process
([Catzc.Base.Git.GitRefs]) — what `git rev-parse HEAD` answers, without starting git.
```
