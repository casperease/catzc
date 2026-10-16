---
catzc:
  derived:
    path: docs/references/automation/catzc-base-docs/private/Get-GlossaryFormViolations.ps1.md
    folder: docs/references/automation/catzc-base-docs/private
    name: get-glossary-form-violations-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: d2cf80b84c52
---

# automation/Catzc.Base.Docs/private/Get-GlossaryFormViolations.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `[string[]]...`, written with `#`.

```text
The scan runs compiled (Catzc.Base.Docs.GlossaryScan): it reads each file's prose through GlossaryProse into the
surface cache once, and matches every concept with forms over the files each glossary source's scope selects.
```
