---
catzc:
  derived:
    path: docs/references/automation/catzc-base-vscode/New-VSCodePipelineSchema.ps1.md
    kind: comment-page
    language: markdown
    filekind: md
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "1965e4d7647d"
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
