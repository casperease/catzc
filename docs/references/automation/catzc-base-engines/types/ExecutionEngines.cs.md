---
catzc:
  derived:
    path: docs/references/automation/catzc-base-engines/types/ExecutionEngines.cs.md
    kind: comment-page
    language: markdown
    filetype: md
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: a3b53b0b7832
---

# automation/Catzc.Base.Engines/types/ExecutionEngines.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
The repository's execution engines — exactly three, pwsh, bash and zsh, declared once
([ADR-AUTO-ENGINE](/docs/adr/automation/execution-engines.md)). Every list of engines in the codebase — config keys
per shell, per-engine fixture columns, an engine argument's allowed values — is Names, so adding or changing an
engine is one edit here.
```

## comment:2

Above `public static readonly ExecutionEngine Zsh = new ExecutionEngine(`, written with `//`.

```text
zsh: the third engine, the default login shell on macOS, located through its tools.yml entry. It shares bash's
POSIX quoting and its importer entry, importer.sh, which runs under both.
```
