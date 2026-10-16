---
catzc:
  derived:
    path: docs/references/automation/catzc-base-codemeta/types/HeadAnchor.cs.md
    kind: comment-page
    language: markdown
    filetype: md
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "5cae5681c9d5"
    adrs:
      - ADR-REPO-CODEMETA#1
---

# automation/Catzc.Base.CodeMeta/types/HeadAnchor.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `namespace Catzc.Base.CodeMeta;`, written with `//`.

```text
What must stay above a comment head: nothing, a shebang, an XML or HTML prolog, or a fixed number of preamble lines.
[ADR-REPO-CODEMETA#1](/docs/adr/repository/code-file-meta.md#rule-adr-repo-codemeta1)
```
