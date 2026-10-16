---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/types/FormatResult.cs.md
    folder: docs/references/automation/catzc-base-qualitygates/types
    name: format-result-cs
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: a1f49dcfadfd
---

# automation/Catzc.Base.QualityGates/types/FormatResult.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
The outcome of formatting one file language (Format-Code -PassThru): the language, the engine languages.yml names for
it, every file the engine checked, and the files it changed — or, under -DryRun, would change. Paths are absolute,
since Format-Code -Path also formats files outside the repository (a built module manifest); Test-Formatting turns
each changed file into one issue naming its repository-relative path.
```
