---
catzc:
  derived:
    path: docs/references/automation/catzc-base-docs/private/Get-GlossaryPhrasingViolations.ps1.md
    kind: comment-page
    body_sha: ce33d990a1fd
---

# automation/Catzc.Base.Docs/private/Get-GlossaryPhrasingViolations.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:4

Above `[string[]]...`.

```text
The scan runs compiled (Catzc.Base.Docs.GlossaryScan): it reads each file's prose through GlossaryProse into the
surface cache once, and matches every avoided phrasing over the files each glossary source's scope selects.
```
