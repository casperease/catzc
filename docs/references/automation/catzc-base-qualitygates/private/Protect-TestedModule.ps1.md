---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/private/Protect-TestedModule.ps1.md
    kind: reference
    body_sha: e18c4d876b2f
    adrs:
      - ADR-REPO-PROTGLOB#4
      - ADR-REPO-PROTGLOB#9
---

# automation/Catzc.Base.QualityGates/private/Protect-TestedModule.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Per-module attribution over the aggregated rows
([ADR-REPO-PROTGLOB#9](/docs/adr/repository/protected-globs.md#rule-adr-repo-protglob9)): a unit is promoted exactly
when it
produced at least one row and none of its rows failed. The rows-present guard is what makes a
failed-but-completed shard safe to attribute around: a worker exits 1 when it CONTAINS failing tests
(their rows name their files precisely), while a unit whose shard died before producing rows yields no
rows and is never promoted. Two cases promote nothing at all: a failed shard with zero failed rows
anywhere (a container/discovery error — nothing is attributable) and a failed row with no file. The
identity promoted is the pending pre-run value
([ADR-REPO-PROTGLOB#4](/docs/adr/repository/protected-globs.md#rule-adr-repo-protglob4)); in a pipeline
Protect-GlobSet is a
no-op anyway.
```
