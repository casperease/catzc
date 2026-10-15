---
catzc:
  derived:
    path: docs/references/automation/catzc-base-globs/Get-GlobSet.ps1.md
    kind: comment-page
    body_sha: "86889955a5e5"
    adrs:
      - ADR-FLOW-CD-GLOBS#1
---

# automation/Catzc.Base.Globs/Get-GlobSet.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The typed read of the single source of truth
([ADR-FLOW-CD-GLOBS#1](/docs/adr/flow/durable-sha-globs.md#rule-adr-flow-cd-globs1)): configs/globs.yml, loaded and
validated
through Get-Config as a [Catzc.Base.Globs.GlobsConfig]. Each result is a [Catzc.Base.Globs.GlobSet]
carrying the compiled include/exclude patterns and Matches(). An unknown name throws, naming the
config file.
```
