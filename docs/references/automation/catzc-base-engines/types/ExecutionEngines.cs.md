# docs/references/automation/catzc-base-engines/types/ExecutionEngines.cs.md

`automation/Catzc.Base.Engines/types/ExecutionEngines.cs`

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `using System;`.

```text
The repository's execution engines — exactly three, pwsh, bash and zsh, declared once
([ADR-AUTO-ENGINE](/docs/adr/automation/execution-engines.md)). Every list of engines in the codebase — config keys
per shell, per-engine fixture columns, an engine argument's allowed values — is Names, so adding or changing an
engine is one edit here.
```

## comment:2

Above `public static readonly ExecutionEngine Zsh = new ExecutionEngine(`.

```text
zsh: the third engine, the default login shell on macOS, located through its tools.yml entry. It shares bash's
POSIX quoting and its importer entry, importer.sh, which runs under both.
```
