---
catzc:
  immutable:
    with_body_sha: a5eb1baf2b99
    repo_status: locked
    path: docs/references/automation/catzc-base-docs/private/Get-GlossaryPhrasingViolations.ps1.md
    folder: docs/references/automation/catzc-base-docs/private
    name: get-glossary-phrasing-violations-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
---

# automation/Catzc.Base.Docs/private/Get-GlossaryPhrasingViolations.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `[string[]]...`, written with `#`.

```text
The scan runs compiled (Catzc.Base.Docs.GlossaryScan): it reads each file's prose through GlossaryProse into the
surface cache once, and matches every avoided phrasing over the files each glossary source's scope selects.
```
