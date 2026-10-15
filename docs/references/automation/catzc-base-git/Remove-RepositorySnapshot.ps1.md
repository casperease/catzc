---
catzc:
  derived:
    path: docs/references/automation/catzc-base-git/Remove-RepositorySnapshot.ps1.md
    kind: comment-page
    body_sha: b58c2dd2b26d
    adrs:
      - ADR-PWSH-ENUM#3
---

# automation/Catzc.Base.Git/Remove-RepositorySnapshot.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:2

Above `foreach ($file in Get-ChildPath $Path -File -Depth 64 -Exclude @()...`.

```text
A named whole-tree walk ([ADR-PWSH-ENUM#3](/docs/adr/pwsh/bounded-enumeration.md#rule-adr-pwsh-enum3)): the
read-only files are mostly git objects under .git, so nothing is pruned.
```
