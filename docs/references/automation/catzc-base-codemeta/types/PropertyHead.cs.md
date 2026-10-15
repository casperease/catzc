---
catzc:
  derived:
    path: docs/references/automation/catzc-base-codemeta/types/PropertyHead.cs.md
    kind: comment-page
    body_sha: "895a696a6731"
    adrs:
      - ADR-REPO-FILEMETA#8
    links: []
---

# automation/Catzc.Base.CodeMeta/types/PropertyHead.cs

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `public string WithFacts(IDictionary derived)`.

```text
The whole text again with the property written from `derived` in the order given and the authored config kept; nothing to write removes it
(ADR-REPO-FILEMETA#8). A text that is no object, or whose property holds something foreign, comes back as it was.
```
