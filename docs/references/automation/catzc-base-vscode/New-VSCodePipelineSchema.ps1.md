---
catzc:
  immutable:
    with_body_sha: "1965e4d7647d"
    path: docs/references/automation/catzc-base-vscode/New-VSCodePipelineSchema.ps1.md
    folder: docs/references/automation/catzc-base-vscode
    name: new-vs-code-pipeline-schema-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
---

# automation/Catzc.Base.VSCode/New-VSCodePipelineSchema.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$rendered = [ordered]@{}`, written with `#`.

```text
Front the schema with its meta-schema declaration, then the authored body in registry order. The '$comment'
provenance marker is the generated-file head, which Build-RootConfig writes (JSON has no comment syntax and
the validator parses this file strictly).
```
