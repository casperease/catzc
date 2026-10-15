---
catzc:
  derived:
    path: docs/adr/repository/code-file-meta.md
    kind: adr
    body_sha: "000000000000"
    adrs: []
---

# ADR: Code file meta — a derived head in the first comment run of a C# type file and a PowerShell function file

## Rules: ADR-REPO-CODEMETA

### Rule ADR-REPO-CODEMETA:1

A code file carries its meta block ([ADR-REPO-FILEMETA#1](file-meta.md#rule-adr-repo-filemeta1)) as a **meta head**: the leading comment run
of the file, opened by a line `catzc:` in the file's own comment syntax, followed by indented `key: value` lines in the registry's order and
one blank line. The head is plain comment text in the language, so the compiler and `Get-Help` ignore it, and no language gains new syntax.
Which prefix a language uses is asked from the one place that knows each language's comments, never written into the head's code.

- [The head is a comment run](#the-head-is-a-comment-run)

### Rule ADR-REPO-CODEMETA:2

A head holds only facts the repository can compute and that change when the file's place or tier changes: `path` (the repository-relative
path), `module` (the folder under `automation/`), and, for a PowerShell file, `visibility` (`private` or `public`, from the folder). It
never holds a hash of the body, which would change on every edit and make every edit a two-hunk diff, and never the ADR codes the file
cites, which are already links ([ADR-REPO-LINK#3](markdown-links.md#rule-adr-repo-link3)). Anything a person wrote stays outside the head.

- [What the head holds](#what-the-head-holds)

### Rule ADR-REPO-CODEMETA:3

The head is imprinted by the same engine, from the same registry, as a Markdown block
([ADR-REPO-FILEMETA#2](file-meta.md#rule-adr-repo-filemeta2), [ADR-REPO-FILEMETA#3](file-meta.md#rule-adr-repo-filemeta3)): a kind is a
registry entry whose globs name code files, and its processor is a function found by convention. The scope is C# type files and PowerShell
function files, less the classes `.gitattributes` exempts ([ADR-REPO-FILEMETA#5](file-meta.md#rule-adr-repo-filemeta5)); tests and asset
files carry no head.

- [Scope](#scope)

### Rule ADR-REPO-CODEMETA:4

`Format-Code` writes the head as an **imprint step** its language names in the file-language registry, after the language's formatter, and
`Test-Formatting` checks the same steps ([ADR-REPO-FORMAT#8](uniform-formatting.md#rule-adr-repo-format8)). No command and no check names a
language's step. A step writes text its formatter leaves unchanged, so the formatter, the step and the formatter again change nothing.

- [Hosted by Format-Code](#hosted-by-format-code)

### Rule ADR-REPO-CODEMETA:5

The comment engine never moves, flags or rewrites a head: a comment head the engine is configured to keep keeps the whole contiguous run it
opens ([ADR-REPO-COMMENTS#3](comments-in-docs.md#rule-adr-repo-comments3)), so the head's continuation lines are not a prose comment and
`Export-Comments` leaves them in the file.

- [The head is a comment run](#the-head-is-a-comment-run)

## Context

A C# type file and a PowerShell function file each open with a comment: an insight line, the citations it rests on and a link to its comment
page. What the file says about itself beyond that, its path, its module and its tier, is either missing or stated twice. The C# namespace is
already derived from the folder and written by a formatter, which shows the shape: a fact the repository can compute is better written by a
tool than typed by a person.

A Markdown file solves the same need with a block in its front matter ([file-meta](file-meta.md)). Code has no front matter, but it has
comments, and a leading comment run is the place a reader looks first.

## Decision

A code file's derived facts sit in a meta head at the top of the file, written by the formatter, in the one registry that already serves
Markdown. The head is small, because every key in it is a key that can drift.

### The head is a comment run

`Plain comments, valid in the language`

```csharp
// catzc:
//   path: automation/Catzc.Base.Languages/types/FileLanguage.cs
//   module: Catzc.Base.Languages

// The insight line of the file's own comment.

using System;
```

```powershell
# catzc:
#   path: automation/Catzc.Base.QualityGates/private/Get-WidgetFact.ps1
#   module: Catzc.Base.QualityGates
#   visibility: private

<#
.SYNOPSIS
    ...
#>
```

The head is a comment, so the compiler ignores it and `Get-Help` reads the help block below it unchanged. A blank line separates it from the
file's own comment, so the comment engine sees two runs. The engine keeps the head's run because the head's opener is one of the heads the
engine is configured to keep, and a kept opener keeps the run it starts.

### What the head holds

`Identity and tier, nothing that moves on every edit`

The path says which file this is, so a copy that kept its old identity is visible. The module says where the file belongs, from the same
source as the namespace. The visibility says whether a PowerShell function is public or private, so a file moved between folders
re-imprints. A hash of the body would change with every edit, so every concurrent edit of one file would conflict on the hash line, and git
already hashes the file. The ADR codes a file cites are already checked links, so a second list would be a second spelling to keep in step.
A hash of the public signature is the one checksum that fits code, and it needs a parser per language, so it is left out until a parser is
warranted.

### Scope

`The authored code, not the tests and not the assets`

The head applies to the files whose names a reader looks up: C# type files and PowerShell function files. Test files carry no help and there
are many of them, so a head there costs more diff than it earns, and asset files are data. A later glob in the registry adds them without
code.

### Hosted by Format-Code

`A configured step, not a new command`

Which steps a language runs after its formatter is one line in the file-language registry, as its formatter is. The C# namespace is such a
step, and the meta head is another, so no check names a step and no command exists per step. The order is the formatter first, then the
steps, then a check that expects no change.

### How this is enforced

- **`Format-Code`** imprints the head through the language's imprint step, and **`Test-Formatting`** fails any file it would change.
- **`Test-FileMetaProcessors`** keeps the head's kinds and their functions in step.
- **`Test-Comments`** fails a head the comment engine would move.

## Consequences

- A code file shows its path, module and tier at the top, written once by a tool, so a copied or moved file cannot keep a stale identity.
- The head never adds noise to a diff, because it changes only when the file's place or tier changes.
- One registry, one engine and one naming convention serve Markdown and code, so a new kind of fact is a registry entry and a function.
- The head costs one blank line and a few comment lines per file and changes no behaviour of the compiled type or the help text.
