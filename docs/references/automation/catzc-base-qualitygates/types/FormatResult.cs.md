# docs/references/automation/catzc-base-qualitygates/types/FormatResult.cs.md

`automation/Catzc.Base.QualityGates/types/FormatResult.cs`

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `using System;`.

```text
The outcome of formatting one file language (Format-Code -PassThru): the language, the engine languages.yml names for
it, every file the engine checked, and the files it changed — or, under -DryRun, would change. Paths are absolute,
since Format-Code -Path also formats files outside the repository (a built module manifest); Test-Formatting turns
each changed file into one issue naming its repository-relative path.
```
