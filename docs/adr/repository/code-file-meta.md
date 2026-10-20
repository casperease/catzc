# ADR: Code file meta — a derived head in the first comment of every tracked code file

## Rules: ADR-REPO-CODEMETA

### Rule ADR-REPO-CODEMETA-CODEFILEHEAD

A code file whose head policy calls for a meta block ([ADR-REPO-FILEMETA-HEADPOLICY](file-meta.md#rule-adr-repo-filemeta-headpolicy))
carries it as a **meta head**: one comment at the top of the file whose text is a front matter document, the same `catzc:` block a Markdown
file carries, written in the registry's order and followed by one blank line. The head is plain comment text in the language, so the
compiler and `Get-Help` ignore it, and no language gains new syntax. A language with block comments wraps the front matter in its
delimiters; a language without them prefixes each line. Which delimiters a language uses is asked from the one place that knows each
language's comments, never written into the head's code.

- [The head is front matter in a comment](#the-head-is-front-matter-in-a-comment)

### Rule ADR-REPO-CODEMETA-COMPUTABLEFACTSONLY

A head holds only facts the repository can compute and that change when the file's place or tier changes: `path` (the repository-relative
path), `role` (the class of the file, the name of the file-kinds registry entry that selects it, never its language, track or module: a
`type`, a `test`, a `gate`, a `function`), `language` (the file language, from the languages registry), `track` (the root concern that holds
the file), `module` (the folder under the modules track's place, when the file is placed in one), for a PowerShell file `visibility`
(`private` or `public`, from the folder), all place facts under `immutable`, and the edges under `edges`: `cites`, the ADR codes that bind
the file, sorted and without duplicates, each rule code `ADR-<CODE>#<n>` and each domain-level citation a bare `ADR-<CODE>`, and `docs`, the
code link to its comment page, and `test` ([ADR-REPO-FILEMETA-FEWLINKS](file-meta.md#rule-adr-repo-filemeta-fewlinks)). For a C# type file,
a PowerShell function file and a PowerShell test file the head holds `cites`: each code the file and its comment page cite that the ADR
index registers, so a fixture code or a placeholder named in prose is no citation, derived on every run and never read back from the head
([ADR-REPO-FILEMETA-NOREADBACK](file-meta.md#rule-adr-repo-filemeta-noreadback)). An authored code file never holds a hash of the body,
which would change on every edit and make every edit a two-hunk diff; a generated one opens with it
([ADR-REPO-FILEMETA-COMPOSEDFILES](file-meta.md#rule-adr-repo-filemeta-composedfiles)), since its writer rewrites the whole file and the
stamp says which content it composed. The facts sit under `immutable` and `edges`, as in Markdown
([ADR-REPO-FILEMETA-FILEISNODE](file-meta.md#rule-adr-repo-filemeta-fileisnode)), and a code head has no `config` part: a code file's prose,
its help included, lives on its comment page ([ADR-REPO-HELP-HELPONCOMMENTPAGE](function-help.md#rule-adr-repo-help-helponcommentpage)).

- [What the head holds](#what-the-head-holds)

### Rule ADR-REPO-CODEMETA-SAMEENGINE

The head is imprinted by the same engine, from the same registry, as a Markdown block
([ADR-REPO-FILEMETA-METAKIND](file-meta.md#rule-adr-repo-filemeta-metakind),
[ADR-REPO-FILEMETA-IMPRINTEDPARTS](file-meta.md#rule-adr-repo-filemeta-imprintedparts)): a kind is a registry entry that selects code files
by their class, and its processor is a function found by convention. The scope is every tracked file whose language the carrier registry
gives a comment head and whose head policy calls for a block, tests and assets included, less the classes `.gitattributes` exempts
([ADR-REPO-FILEMETA-KINDSCOPE](file-meta.md#rule-adr-repo-filemeta-kindscope)). Every such file carries `path` and `role`; `module` and
`visibility` stay with the C# type files and PowerShell function files their kinds name, and the `cites` edge goes to those and to the
PowerShell test files, whose prose moves to a comment page like any other file's.

- [Scope](#scope)

### Rule ADR-REPO-CODEMETA-IMPRINTSTEP

`Format-Code` writes the head as an imprint step
([ADR-REPO-FORMAT-CONFIGUREDFORMATTERS](uniform-formatting.md#rule-adr-repo-format-configuredformatters)). The step is global: the
file-language registry lists it once, so it runs after the formatter of every language, and the carrier registry says which files carry a
head and where. `Test-Formatting` checks the same step. No command and no check names a language's step. A step writes text its formatter
leaves unchanged, so the formatter, the step and the formatter again change nothing. The same entry lists the openers of old heads the step
removes with their comment run before it writes the head, so a retired form never stands beside the current one.

- [Hosted by Format-Code](#hosted-by-format-code)

### Rule ADR-REPO-CODEMETA-COMMENTSLEAVEHEAD

The comment engine never moves, flags or rewrites a head: a comment whose front matter opens with a head listed under `keep_run:` in
`comments.yml` ([ADR-REPO-COMMENTS-COMMENTPAGEPLACE](comments-in-docs.md#rule-adr-repo-comments-commentpageplace)) is not a prose comment,
so `Export-Comments` leaves it in the file.

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
  immutable:
    path: pwsh/Catzc.Base.Languages/types/FileLanguage.cs
    role: type
    module: Catzc.Base.Languages
  edges:
    cites:
      - ADR-AUTO-TYPES-ONETYPEPERFILE
---
*/

// The insight line of the file's own comment.

using System;
```

```powershell
<#
---
catzc:
  immutable:
    path: pwsh/Catzc.Base.QualityGates/private/Get-WidgetFact.ps1
    role: function
    module: Catzc.Base.QualityGates
    visibility: private
---
#>

function Get-WidgetFact {
}
```

Without the comment delimiters the head is the front matter of a Markdown file, so one reader of the `catzc` block serves both and a tool
that knows one knows the other. The head is a comment, so the compiler ignores it. A blank line separates it from the file's own comment.
The comment engine keeps the head because its front matter opens with a head listed to keep, whatever the language's delimiters are.

### What the head holds

`Identity and tier, nothing that moves on every edit`

The path says which file this is, so a copy that kept its old identity is visible. The kind says what class of file it is, from the same
registry entry that classifies Markdown files, so a type and a function are told apart by data, not by a reader's guess. The module says
where the file belongs, from the same source as the namespace. The visibility says whether a PowerShell function is public or private, so a
file moved between folders re-imprints. A hash of the body would change with every edit, so every concurrent edit of one file would conflict
on the hash line, and git already hashes the file. The ADR codes a file cites are the one list a reader scans to learn which decisions bind
the file, so the head shows them, rebuilt on every run from the citations the file and its comment page make: a code the text no longer
spells out no longer binds the file, and a list that kept it would say something the file does not. A hash of the public signature is the
one checksum that fits code, and it needs a parser per language, so it is left out until a parser is warranted.

### Scope

`Every tracked file that is not vendored`

Every tracked file a reader can open says what it is and where it belongs, so a test, an asset, a script or a template carries the same
`path` and `role` as a function does. The carrier registry already knows each language's comment syntax, so the scope comes from it and no
meta kind repeats a list of globs. The files the head would harm stay out through `.gitattributes`: vendored code is someone else's,
contract assets and fixtures are compared byte for byte, and generated files carry the head their writer wrote
([ADR-REPO-FILEMETA-COMPOSEDFILES](file-meta.md#rule-adr-repo-filemeta-composedfiles)). The richer keys stay with the files that have them:
a module and a visibility belong to a function or a type.

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
