---
catzc:
  derived:
    path: docs/references/automation/catzc-base-git/tests/New-RepositorySnapshot.Tests.ps1.md
    kind: test-asset
    body_sha: "74a921a36119"
---

# automation/Catzc.Base.Git/tests/New-RepositorySnapshot.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'New-RepositorySnapshot' -Tag 'L2', 'logic' {`.

```text
L2: drives real git against a throwaway repository that holds every working-tree state a snapshot must
reproduce — staged, unstaged, staged-then-edited, untracked, deleted, ignored — plus LF bytes under
core.autocrlf=true (a checkout would rewrite them as CRLF; the snapshot must not).
```
