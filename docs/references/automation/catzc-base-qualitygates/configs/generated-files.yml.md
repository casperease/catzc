---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/configs/generated-files.yml.md
    kind: comment-page
    body_sha: d75bf1bf9c20
    adrs:
      - ADR-AUTO-TEST#35
---

# automation/Catzc.Base.QualityGates/configs/generated-files.yml

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `writers:`.

```text
The writers Test-GeneratedFiles runs report-only (ADR-AUTO-TEST#35); a file result names its stale file in the property result_path
(default Path). The generators of the managed root files are the generator keys of rootconfig.yml, so they are never listed here.
```
