---
catzc:
  derived:
    path: docs/references/automation/catzc-base-asserts/Test-IsGuidInRange.ps1.md
    kind: comment-page
    body_sha: "7a520a937e35"
    adrs: []
---

# automation/Catzc.Base.Asserts/Test-IsGuidInRange.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Orders GUIDs by their 128 bits as written — the canonical lowercase hyphenated form, compared ordinally — which
is how a reader sees a range in config, whatever case or braces the inputs use. A non-GUID input, or a range
whose From is after its To, is a caller error and throws.
```
