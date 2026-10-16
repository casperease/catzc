---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/configs/generated-files.yml.md
    kind: comment-page
    language: markdown
    filetype: md
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: b2ac99e2051e
    adrs:
      - ADR-AUTO-TEST#35
---

# automation/Catzc.Base.QualityGates/configs/generated-files.yml

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `writers:`, written with `#`.

```text
The writers Test-GeneratedFiles runs report-only (ADR-AUTO-TEST#35); a file result names its stale file in the property result_path
(default Path). The generators of the managed root files are the generator keys of rootconfig.yml, so they are never listed here.
```
