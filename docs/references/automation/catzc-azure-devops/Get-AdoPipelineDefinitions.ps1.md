---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-devops/Get-AdoPipelineDefinitions.ps1.md
    kind: comment-page
    language: markdown
    filekind: md
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: ad282d62831d
---

# automation/Catzc.Azure.DevOps/Get-AdoPipelineDefinitions.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$hasProcessDetails = $definitions | Where-Object { $_.process.yamlFilename }...`, written with `#`.

```text
includeAllProperties should return process.yamlFilename inline.
Older ADO Server versions may ignore this — fall back to per-definition fetches.
```
