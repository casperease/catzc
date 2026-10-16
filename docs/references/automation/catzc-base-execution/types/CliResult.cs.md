---
catzc:
  immutable:
    with_body_sha: d62ab0214fc7
    path: docs/references/automation/catzc-base-execution/types/CliResult.cs.md
    folder: docs/references/automation/catzc-base-execution/types
    name: cli-result-cs
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
---

# automation/Catzc.Base.Execution/types/CliResult.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
The captured result of running an external command: stdout and stderr kept separate, plus convenience
views derived from them. The constructor owns the derivation, so the result can never be in an
inconsistent state (the views always agree with Output/Errors).
```

## comment:2

Above `public byte[] Bytes { get; }`, written with `//`.

```text
The exact stdout bytes of a binary run (Invoke-Executable -AsBytes); null for a text run, whose stdout is
Output. A binary run's Output is empty: its stdout is not text.
```
