---
catzc:
  derived:
    path: docs/references/automation/catzc-base-files/private/Get-GitIndexPath.ps1.md
    kind: comment-page
    body_sha: ea06dc818df0
    adrs: []
    links: []
---

# automation/Catzc.Base.Files/private/Get-GitIndexPath.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The index of the checkout at Get-RepositoryRoot: `<root>/.git/index` for a plain checkout, or
`<gitdir>/index` when `.git` is a file (`gitdir: <path>` — a linked worktree or a submodule), with a
relative gitdir resolved against the root ([Catzc.Base.Git.GitRefs], read in-process). Throws when the root
is not a git checkout. The file itself may be absent (a fresh `git init` with nothing added) — the caller
reads that as "nothing tracked".
```
