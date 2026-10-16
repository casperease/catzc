---
catzc:
  derived:
    path: docs/adr/repository/code-file-meta.md
    kind: adr
    language: markdown
    track: docs
    body_sha: dd2ec1253847
    defines:
      - ADR-REPO-CODEMETA#{1-5}
    adrs:
      - ADR-REPO-COMMENTS#3
      - ADR-REPO-FILEMETA#{1-3,5,7}
      - ADR-REPO-FORMAT#8
    links:
      - docs/adr/repository/comments-in-docs.md#rule-adr-repo-comments3
      - docs/adr/repository/file-meta.md
      - docs/adr/repository/file-meta.md#rule-adr-repo-filemeta1
      - docs/adr/repository/file-meta.md#rule-adr-repo-filemeta2
      - docs/adr/repository/file-meta.md#rule-adr-repo-filemeta3
      - docs/adr/repository/file-meta.md#rule-adr-repo-filemeta5
      - docs/adr/repository/file-meta.md#rule-adr-repo-filemeta7
      - docs/adr/repository/uniform-formatting.md#rule-adr-repo-format8
---

# ADR: Code file meta — a derived head in the first comment of every tracked code file

## Rules: ADR-REPO-CODEMETA

### Rule ADR-REPO-CODEMETA:1

A code file carries its meta block ([ADR-REPO-FILEMETA#1](file-meta.md#rule-adr-repo-filemeta1)) as a **meta head**: one comment at the top
of the file whose text is a front matter document, the same `catzc:` block a Markdown file carries, written in the registry's order and
followed by one blank line. The head is plain comment text in the language, so the compiler and `Get-Help` ignore it, and no language gains
new syntax. A language with block comments wraps the front matter in its delimiters; a language without them prefixes each line. Which
delimiters a language uses is asked from the one place that knows each language's comments, never written into the head's code.

- [The head is front matter in a comment](#the-head-is-front-matter-in-a-comment)

### Rule ADR-REPO-CODEMETA:2

A head holds only facts the repository can compute and that change when the file's place or tier changes: `path` (the repository-relative
path), `kind` (the class of the file, a moniker of the file-kind registry entry that names its language and role: a `csharp-type`, a
`pester-test`, a `gate-function`, an `automation-function`), `module` (the folder under `automation/`), for a PowerShell file `visibility`
(`private` or `public`, from the folder), and `adrs`, the ADR codes that bind the file, sorted and without duplicates, each rule code
`ADR-<CODE>#<n>` and each domain-level citation a bare `ADR-<CODE>`. For a C# type file, a PowerShell function file and a PowerShell test
file the head holds `adrs`: the formatter keeps every code the head lists and adds each code the file and its comment page cite that the ADR
index registers, so a fixture code or a placeholder named in prose is no citation, and a code leaves the list only when a person deletes it
from the head. It never holds a hash of the body, which would change on every edit and make every edit a two-hunk diff. The facts sit under
`derived`, and a person's own keys, if any, sit under `config`, as in Markdown.

- [What the head holds](#what-the-head-holds)

### Rule ADR-REPO-CODEMETA:3

The head is imprinted by the same engine, from the same registry, as a Markdown block
([ADR-REPO-FILEMETA#2](file-meta.md#rule-adr-repo-filemeta2), [ADR-REPO-FILEMETA#3](file-meta.md#rule-adr-repo-filemeta3)): a kind is a
registry entry that selects code files by their class, and its processor is a function found by convention. The scope is every tracked file
whose language the carrier registry gives a comment head, tests and assets included, less the classes `.gitattributes` exempts
([ADR-REPO-FILEMETA#5](file-meta.md#rule-adr-repo-filemeta5)). Every such file carries `path` and `kind`; `module` and `visibility` stay
with the C# type files and PowerShell function files their kinds name, and `adrs` goes to those and to the PowerShell test files, whose
prose moves to a comment page like any other file's.

- [Scope](#scope)

### Rule ADR-REPO-CODEMETA:4

`Format-Code` writes the head as an imprint step ([ADR-REPO-FORMAT#8](uniform-formatting.md#rule-adr-repo-format8)). The step is global: the
file-language registry lists it once, so it runs after the formatter of every language, and the carrier registry says which files carry a
head and where. `Test-Formatting` checks the same step. No command and no check names a language's step. A step writes text its formatter
leaves unchanged, so the formatter, the step and the formatter again change nothing. The same entry lists the openers of old heads the step
removes with their comment run before it writes the head, so a retired form never stands beside the current one.

- [Hosted by Format-Code](#hosted-by-format-code)

### Rule ADR-REPO-CODEMETA:5

The comment engine never moves, flags or rewrites a head: a comment whose front matter opens with a head listed under `keep_run:` in
`comments.yml` ([ADR-REPO-COMMENTS#3](comments-in-docs.md#rule-adr-repo-comments3)) is not a prose comment, so `Export-Comments` leaves it
in the file.

- [The head is front matter in a comment](#the-head-is-front-matter-in-a-comment)

## Context

A C# type file and a PowerShell function file each open with a comment that cites the rules it rests on. What the file says about itself
beyond that, its path, its module, its tier and the files that belong to it, is either missing or stated twice. The C# namespace is already
derived from the folder and written by a formatter, which shows the shape: a fact the repository can compute is better written by a tool
than typed by a person.

A Markdown file solves the same need with a block in its front matter ([file-meta](file-meta.md)). Code has no front matter, but it has
comments, and a leading comment run is the place a reader looks first.

## Decision

A code file's derived facts sit in a meta head at the top of the file, written by the formatter, in the one registry that already serves
Markdown. The head is small, because every key in it is a key that can drift.

### The head is front matter in a comment

`One parser for every file, plain comments in the language`

```csharp
/*
---
catzc:
  derived:
    path: automation/Catzc.Base.Languages/types/FileLanguage.cs
    kind: type
    module: Catzc.Base.Languages
---
*/

// The insight line of the file's own comment.

using System;
```

```powershell
<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/private/Get-WidgetFact.ps1
    kind: function
    module: Catzc.Base.QualityGates
    visibility: private
---
#>

<#
.SYNOPSIS
    ...
#>
```

Without the comment delimiters the head is the front matter of a Markdown file, so one reader of the `catzc` block serves both and a tool
that knows one knows the other. The head is a comment, so the compiler ignores it and `Get-Help` reads the help block next to the function
unchanged. A blank line separates it from the file's own comment. The comment engine keeps the head because its front matter opens with a
head listed to keep, whatever the language's delimiters are.

### What the head holds

`Identity and tier, nothing that moves on every edit`

The path says which file this is, so a copy that kept its old identity is visible. The kind says what class of file it is, from the same
registry entry that classifies Markdown files, so a type and a function are told apart by data, not by a reader's guess. The module says
where the file belongs, from the same source as the namespace. The visibility says whether a PowerShell function is public or private, so a
file moved between folders re-imprints. A hash of the body would change with every edit, so every concurrent edit of one file would conflict
on the hash line, and git already hashes the file. The ADR codes a file cites are the one list a reader scans to learn which decisions bind
the file, so they sit in the head, and the head is where they live: the residue carries no citation of its own, so there is no second
spelling to keep in step, and a list rebuilt from the text alone would lose every code the text no longer spells out. The formatter only
adds to the list, from the citations the file and its comment page make, and the classes a kind names under `held_classes` are the ones
whose head holds it. A hash of the public signature is the one checksum that fits code, and it needs a parser per language, so it is left
out until a parser is warranted.

### Scope

`Every tracked file that is not vendored`

Every tracked file a reader can open says what it is and where it belongs, so a test, an asset, a script or a template carries the same
`path` and `kind` as a function does. The carrier registry already knows each language's comment syntax, so the scope comes from it and no
meta kind repeats a list of globs. The files the head would harm stay out through `.gitattributes`: vendored code is someone else's,
contract assets and fixtures are compared byte for byte, and generated files carry the head their writer wrote
([ADR-REPO-FILEMETA#7](file-meta.md#rule-adr-repo-filemeta7)). The richer keys stay with the files that have them: a module and a visibility
belong to a function or a type.

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
