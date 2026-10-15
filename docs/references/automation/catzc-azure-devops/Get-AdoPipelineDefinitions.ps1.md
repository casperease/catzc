---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-devops/Get-AdoPipelineDefinitions.ps1.md
    kind: comment-page
    body_sha: "5e6ec358d132"
---

# automation/Catzc.Azure.DevOps/Get-AdoPipelineDefinitions.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:3

Above `$hasProcessDetails = $definitions | Where-Object { $_.process.yamlFilename }...`.

```text
includeAllProperties should return process.yamlFilename inline.
Older ADO Server versions may ignore this — fall back to per-definition fetches.
```
