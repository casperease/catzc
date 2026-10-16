---
catzc:
  immutable:
    with_body_sha: "954aeb4113e5"
    path: docs/references/automation/catzc-base-docs/types/GlossarySegment.cs.md
    folder: docs/references/automation/catzc-base-docs/types
    name: glossary-segment-cs
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
---

# automation/Catzc.Base.Docs/types/GlossarySegment.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `namespace Catzc.Base.Docs;`, written with `//`.

```text
One piece of prose the glossary checks read (G4, G6): the surface it comes from (markdown, comments, help, messages),
the line it starts on, and its text with code and mentions blanked to spaces so a match's offset still maps to its
line. GlossaryProse produces them; GlossaryScan reads them.
```
