---
catzc:
  derived:
    path: docs/references/automation/catzc-base-files/Get-GitCurrentBranch.ps1.md
    kind: comment-page
    body_sha: "60e14984b093"
    adrs: []
    links: []
---

# automation/Catzc.Base.Files/Get-GitCurrentBranch.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The branch HEAD is on in the checkout at Get-RepositoryRoot, read from its HEAD file in-process
([Catzc.Base.Git.GitRefs]) — what `git rev-parse --abbrev-ref HEAD` answers, without starting git.
```
