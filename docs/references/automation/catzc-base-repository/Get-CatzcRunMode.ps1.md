---
catzc:
  derived:
    path: docs/references/automation/catzc-base-repository/Get-CatzcRunMode.ps1.md
    kind: comment-page
    body_sha: e54b450daaab
    adrs:
      - ADR-DSGN-RUNMODE#4
    links: []
---

# automation/Catzc.Base.Repository/Get-CatzcRunMode.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The mode is derived, never stored
([ADR-DSGN-RUNMODE#4](/docs/adr/design/run-modes.md#rule-adr-dsgn-runmode4)). It is 'source' when the code root
(Get-CatzcModulesRoot) is <RepositoryRoot>/automation — the modules were loaded in place by importer.ps1 — and
'build' otherwise, when the modules were loaded from a built Catzc package by its Import-Catzc.ps1. The two
roots are compared as normalized full paths, case-insensitively, so a trailing separator or a mixed-case
drive letter never flips the answer.
```
