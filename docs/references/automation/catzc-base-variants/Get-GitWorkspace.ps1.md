---
catzc:
  derived:
    path: docs/references/automation/catzc-base-variants/Get-GitWorkspace.ps1.md
    kind: comment-page
    body_sha: d3297b2dbcd7
    adrs: []
    links: []
---

# automation/Catzc.Base.Variants/Get-GitWorkspace.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The `git_workspace` repo-wide variant (configs/variants.yml), fixed for the importer session: how
changes reach main. 'main-direct' (the default) is the solo-author trunk — direct commits to main are
allowed, including automation's own (Sync-GeneratedFile). 'main-via-pr' means everything reaches main
through a PR: local work always happens on a branch, so committing is still always allowed there — the
single stop condition is a direct commit made while standing on main locally (Test-GitWorkspace guards
it). Flip to 'main-via-pr' when the repo goes from one author to more.
```
