# pwsh/Base.Docs/types/GlossaryProse.cs

The prose of one file, as the glossary checks read it (G4, G6): never a regex over source text
([ADR-REPO-VOCAB-AVOIDEDPHRASINGREPLACED](../../../../drs/repository/controlled-vocabulary.md#rule-adr-repo-vocab-avoidedphrasingreplaced)).
It produces [GlossarySegment](GlossarySegment.cs.md)s, which [GlossaryScan](GlossaryScan.cs.md) reads.

## What a file yields

- **Markdown** — the whole file as one `markdown` segment, fenced code blocks blanked. It also blanks what is not prose: a link or image
  destination, the `(path)` after `]`, and the title line that names the file's own repository path
  ([ADR-REPO-FORMAT-MARKDOWNTITLE](../../../../drs/repository/uniform-formatting.md#rule-adr-repo-format-markdowntitle)).
- **PowerShell** — the real parser's tokens and AST: `help` (a block comment holding `.SYNOPSIS` or `.DESCRIPTION`), `comments` (every other
  comment), and `messages`, the strings passed to `throw`, `Write-Message`, `Write-Warning`, `Write-Error` or `Write-Host`, and the value of
  any `-ErrorText` or `-Because` parameter. A constant string gives its value; an expandable string its value with every embedded variable or
  sub-expression removed. A string several of those contexts hold is read once.

Every segment's mentions, `code`, "quoted" and “curly-quoted” spans that do not cross a blank line, are blanked to spaces (`RemoveMentions`),
and it carries the line it starts on, so a match's offset maps to its line.

## Message carriers

The argument elements that carry a message are everything after the command name of a writer, the operand of `throw`, and the value of
`-ErrorText` or `-Because` on any command. A string inside an expandable string's sub-expression is code, not message text, so its parent
string drops it with the rest of the sub-expression.

## Code heads

A code head's `immutable:` block holds facts the engine computed from the file (its name, kind, module), not prose. Its lines are blanked, as
the Markdown reader blanks the meta block, and the line count is kept so later lines keep their numbers.
