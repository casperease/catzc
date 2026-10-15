---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/private/Get-GuidScanFiles.ps1.md
    kind: comment-page
    body_sha: "69e8ec14f316"
---

# automation/Catzc.Base.QualityGates/private/Get-GuidScanFiles.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:3

Above `Assert-SourceTree`.

```text
The universe and its exclusions (automation/.vendor, automation/.compiled, the registry) are the catzc
source repository's layout, so the scan is meaningful only over the source tree.
```
