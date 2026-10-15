---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-devops/tests/types/PipelineEnvConfig.Tests.ps1.md
    kind: test-asset
    body_sha: "23c7346b4d42"
---

# automation/Catzc.Azure.DevOps/tests/types/PipelineEnvConfig.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'Catzc.Azure.DevOps.PipelineEnvConfig' -Tag 'L0' {`.

```text
The pipeline-env.yml type: constructing it maps and validates the parsed YAML, so a malformed whitelist never
loads through Get-Config -Config pipeline-env.
```
