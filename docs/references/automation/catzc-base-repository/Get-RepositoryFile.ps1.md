---
catzc:
  derived:
    path: docs/references/automation/catzc-base-repository/Get-RepositoryFile.ps1.md
    kind: comment-page
    body_sha: b784797b098e
    adrs:
      - ADR-AUTO-PATH#7
---

# automation/Catzc.Base.Repository/Get-RepositoryFile.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
A binding helper (see
[ADR-AUTO-PATH#7](/docs/adr/automation/path-representation.md#rule-adr-auto-path7)): it takes a
repo-relative path and returns the normalized absolute path to bind against — '.\', '..', and mixed
separators collapse, so a leading './' never leaks into the result. Resolution is against the
repository root, not $PWD. Delegates to Resolve-RepoPath so the normalization lives in one place.
```
