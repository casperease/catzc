# pwsh/Catzc.Base.GeneratedFiles/types/GeneratedWriter.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
One writer Test-GeneratedFiles runs report-only; every default is declared here once (ADR-AUTO-DEFAULT-ONERESOLUTIONORDER).
The check says which report shape the writer's -PassThru result has.
```

## comment:2

Above `public string check { get; }`, written with `//`.

```text
How the writer is checked: file (one result per file, with a path property), english-dictionary (the committed list against its stamp),
or root-config (the managed root files, each attributed to the generator the root-config registry names). Default: file.
```
