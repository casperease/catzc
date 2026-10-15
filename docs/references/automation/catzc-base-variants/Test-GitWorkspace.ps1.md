---
catzc:
  derived:
    path: docs/references/automation/catzc-base-variants/Test-GitWorkspace.ps1.md
    kind: comment-page
    body_sha: "5a1c187754b3"
---

# automation/Catzc.Base.Variants/Test-GitWorkspace.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
A predicate over the `git_workspace` repo-wide variant (see Get-GitWorkspace). Pass exactly one of
-MainDirect or -MainViaPr; returns $true when the repo's mode matches. The canonical consumer shape is
the stop condition for automated commits: `(Test-GitWorkspace -MainViaPr) -and <on main locally>` — in
main-via-pr mode local work always happens on a branch, so standing on main is the only place a direct
commit is forbidden.
```
