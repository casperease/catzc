---
catzc:
  derived:
    path: docs/references/automation/catzc-base-vscode/tests/types/VscodePipelineSchemaConfig.Tests.ps1.md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: dbb5c6f2ca2b
---

# automation/Catzc.Base.VSCode/tests/types/VscodePipelineSchemaConfig.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Catzc.Base.VSCode.VscodePipelineSchemaConfig' -Tag 'L0' {`, written with `#`.

```text
The vscode-pipeline-schema.yml type: constructing it maps and validates the parsed YAML, so a schema that would
reintroduce the false positives it exists to remove never loads through Get-Config -Config vscode-pipeline-schema.
```
