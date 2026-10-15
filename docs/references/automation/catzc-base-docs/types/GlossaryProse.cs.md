# docs/references/automation/catzc-base-docs/types/GlossaryProse.cs.md

`automation/Catzc.Base.Docs/types/GlossaryProse.cs`

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `using System;`.

```text
The prose of one file, as the glossary checks read it (G4, G6): never a regex over source text
([ADR-REPO-VOCAB#5](/docs/adr/repository/controlled-vocabulary.md#rule-adr-repo-vocab5)).
  Markdown    the whole file as one 'markdown' segment, fenced code blocks blanked;
  PowerShell  the real parser's tokens and AST: 'help' (a block comment holding .SYNOPSIS or .DESCRIPTION),
              'comments' (every other comment), and 'messages' — the strings passed to throw, Write-Message,
              Write-Warning, Write-Error or Write-Host, and the value of any -ErrorText or -Because parameter. A
              constant string gives its value; an expandable string its value with every embedded variable or
              sub-expression removed. A string several of those contexts hold is read once.
Every segment's mentions — `code`, "quoted" and “curly-quoted” spans that do not cross a blank line — are blanked to
spaces (RemoveMentions), and it carries the line it starts on, so a match's offset maps to its line. Markdown also
blanks what is not prose: a link or image destination, the `(path)` after `]`, and the title line that names the
file's own repository path ([ADR-REPO-FORMAT#6](/docs/adr/repository/uniform-formatting.md#rule-adr-repo-format6)).
```

## comment:2

Above `List<Ast> carriers = new List<Ast>();`.

```text
The argument elements that carry a message: everything after the command name of a writer, the operand of
throw, and the value of -ErrorText / -Because on any command.
```

## comment:3

Above `bool inExpandable = false;`.

```text
A string inside an expandable string's sub-expression is code, not message text: its parent string
drops it with the rest of the sub-expression.
```
