---
catzc:
  derived:
    path: docs/references/automation/catzc-base-vscode/New-VSCodePipelineSchema.ps1.md
    kind: comment-page
    body_sha: "322b3c3655f6"
---

# automation/Catzc.Base.VSCode/New-VSCodePipelineSchema.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:3

Above `$rendered = [ordered]@{}`.

```text
Front the schema with its meta-schema declaration, then the authored body in registry order. The '$comment'
provenance marker is the generated-file head, which Build-RootConfig writes (JSON has no comment syntax and
the validator parses this file strictly).
```
