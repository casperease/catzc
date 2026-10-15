---
catzc:
  derived:
    path: docs/references/automation/catzc-base-git/Remove-RepositorySnapshot.ps1.md
    kind: comment-page
    body_sha: "14c9b5750d9a"
    adrs:
      - ADR-PWSH-ENUM#3
---

# automation/Catzc.Base.Git/Remove-RepositorySnapshot.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `foreach ($file in Get-ChildPath $Path -File -Depth 64 -Exclude @()...`, written with `#`.

```text
A named whole-tree walk ([ADR-PWSH-ENUM#3](/docs/adr/pwsh/bounded-enumeration.md#rule-adr-pwsh-enum3)): the
read-only files are mostly git objects under .git, so nothing is pruned.
```
