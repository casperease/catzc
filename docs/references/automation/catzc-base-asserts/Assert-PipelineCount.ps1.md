---
catzc:
  derived:
    path: docs/references/automation/catzc-base-asserts/Assert-PipelineCount.ps1.md
    kind: comment-page
    body_sha: f6563297252f
    adrs: []
    links: []
---

# automation/Catzc.Base.Asserts/Assert-PipelineCount.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Counts pipeline objects and validates against -Equals, -Minimum, or -Maximum.
Objects are passed through. Fails early when the count exceeds -Equals or -Maximum.
```
