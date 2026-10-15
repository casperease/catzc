---
catzc:
  derived:
    path: docs/references/automation/catzc-base-asserts/Assert-HaveProperty.ps1.md
    kind: comment-page
    body_sha: "81af8fc5a0e2"
    adrs: []
    links: []
---

# automation/Catzc.Base.Asserts/Assert-HaveProperty.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.PARAMETER PropertyName` of the comment-based help.

```text
The property name that must exist on the object. Dotted paths
(e.g. 'parent.child.etc.value') are walked level by level; the failure
message names the deepest segment that was reached before the chain broke.
```
