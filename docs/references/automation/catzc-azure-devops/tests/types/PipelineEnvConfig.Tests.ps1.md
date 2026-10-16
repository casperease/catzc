---
catzc:
  immutable:
    with_body_sha: a6fa15cd4af2
    path: docs/references/automation/catzc-azure-devops/tests/types/PipelineEnvConfig.Tests.ps1.md
    folder: docs/references/automation/catzc-azure-devops/tests/types
    name: pipeline-env-config-tests-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
---

# automation/Catzc.Azure.DevOps/tests/types/PipelineEnvConfig.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Catzc.Azure.DevOps.PipelineEnvConfig' -Tag 'L0' {`, written with `#`.

```text
The pipeline-env.yml type: constructing it maps and validates the parsed YAML, so a malformed whitelist never
loads through Get-Config -Config pipeline-env.
```
