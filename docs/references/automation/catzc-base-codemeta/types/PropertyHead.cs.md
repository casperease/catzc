---
catzc:
  derived:
    path: docs/references/automation/catzc-base-codemeta/types/PropertyHead.cs.md
    kind: comment-page
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: ae63f2f8bf8b
    adrs:
      - ADR-REPO-FILEMETA#8
---

# automation/Catzc.Base.CodeMeta/types/PropertyHead.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `public string WithFacts(IDictionary derived)`, written with `//`.

```text
The whole text again with the property written from `derived` in the order given and the authored config kept; nothing to write removes it
(ADR-REPO-FILEMETA#8). A text that is no object, or whose property holds something foreign, comes back as it was.
```
