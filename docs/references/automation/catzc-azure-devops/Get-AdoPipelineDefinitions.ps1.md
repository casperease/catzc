---
catzc:
  immutable:
    with_body_sha: ad282d62831d
    repo_status: locked
    path: docs/references/automation/catzc-azure-devops/Get-AdoPipelineDefinitions.ps1.md
    folder: docs/references/automation/catzc-azure-devops
    name: get-ado-pipeline-definitions-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
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
