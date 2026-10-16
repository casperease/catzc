---
catzc:
  immutable:
    with_body_sha: "4fc7c7757669"
    repo_status: locked
    path: docs/references/automation/catzc-base-codemeta/types/HeadForm.cs.md
    folder: docs/references/automation/catzc-base-codemeta/types
    name: head-form-cs
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
  edges:
    cites:
      - ADR-REPO-CODEMETA#1
---

# automation/Catzc.Base.CodeMeta/types/HeadForm.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
The comment syntax of one file class's meta head, handed in as parameters because this module reads no config.
[ADR-REPO-CODEMETA#1](/docs/adr/repository/code-file-meta.md#rule-adr-repo-codemeta1)
```
