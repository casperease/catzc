---
catzc:
  immutable:
    with_body_sha: dd065c79282c
    repo_status: locked
    path: docs/references/automation/catzc-base-docs/Build-Glossary.ps1.md
    folder: docs/references/automation/catzc-base-docs
    name: build-glossary-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
---

# automation/Catzc.Base.Docs/Build-Glossary.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$inputsSha = Get-InputStamp -Path @(`, written with `#`.

```text
Every input of the page: the glossary sources, the domain order, the ADR files the defining rules link into, and the code that renders.
An unchanged stamp means the page on disk was written from exactly these, so nothing is read or rendered. -PassThru wants the concept count, so it renders.
```
