# ADR: Code file meta — a navigation head in the first comment of an authored code file

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

An authored code or config file's head is the **navigation head**, and it holds exactly two edges under `edges`: `cites`, the rule codes
that bind the file, sorted and without duplicates, each a rule code or a bare domain-level code, and `docs`, the link to its comment page by
its path from the file's own folder ([ADR-REPO-FILEMETA-FEWLINKS](file-meta.md#rule-adr-repo-filemeta-fewlinks)). Each edge is left out when
it has no target, and a file with neither carries no head ([ADR-REPO-FILEMETA-HEADPOLICY](file-meta.md#rule-adr-repo-filemeta-headpolicy)).
`cites` is each code the file and its comment page cite that the DRS index registers, so a fixture code or a placeholder named in prose is
no citation, derived on every run and never read back from the head
([ADR-REPO-FILEMETA-NOREADBACK](file-meta.md#rule-adr-repo-filemeta-noreadback)). The head has no `immutable` part: no `with_body_sha`,
which would change on every edit of the body and tell a reader nothing, and no `test` or `code` edge, since a test is found by convention,
its stem under `tests/`. Every place fact, the path, the role, the language, the track, the module and the visibility, is derived on demand
and never written into the head. A code head has no `config` part: a code file's prose, its help included, lives on its comment page
([ADR-REPO-HELP-HELPONCOMMENTPAGE](function-help.md#rule-adr-repo-help-helponcommentpage)). A generated code file carries the generated-file
head instead ([ADR-REPO-FILEMETA-COMPOSEDFILES](file-meta.md#rule-adr-repo-filemeta-composedfiles)).

- [What the head holds](#what-the-head-holds)

### Rule ADR-REPO-CODEMETA-SAMEENGINE

The head is imprinted by the same engine, from the same registry, as a Markdown block
([ADR-REPO-FILEMETA-METAKIND](file-meta.md#rule-adr-repo-filemeta-metakind),
[ADR-REPO-FILEMETA-IMPRINTEDPARTS](file-meta.md#rule-adr-repo-filemeta-imprintedparts)): a kind is a registry entry, and its processor is a
function found by convention. The scope is the head policy ([ADR-REPO-FILEMETA-HEADPOLICY](file-meta.md#rule-adr-repo-filemeta-headpolicy)):
every authored file whose carrier is a comment head or a JSON property and that has a `docs` or `cites` edge carries the navigation head,
tests and configs included, less the classes `.gitattributes` exempts
([ADR-REPO-FILEMETA-KINDSCOPE](file-meta.md#rule-adr-repo-filemeta-kindscope)); every other authored file carries none, and the engine
strips a head it holds. The kinds that fill the head select no files of their own, so they apply to every file the policy gives a head.

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

A C# type file and a PowerShell function file each rest on rules and have a page that holds their long comments. A reader who opens the file
on GitHub or in an editor wants those one step away, and finding each costs a search. Every other fact about the file, its path, its module,
its tier, its test under `tests/`, the repository already knows and answers on demand.

A Markdown file solves a similar need with a block in its front matter ([file-meta](file-meta.md)). Code has no front matter, but it has
comments, and a leading comment run is the place a reader looks first.

## Decision

An authored code file's edges sit in a navigation head at the top of the file, written by the formatter, in the one registry that already
serves Markdown, and only where the file has a page or rules to cite. The head is small, because every key in it is a key that can drift.

### The head is front matter in a comment

`One parser for every file, plain comments in the language`

```csharp
/*
---
catzc:
  edges:
    cites:
      - ADR-BCL-TYPES-ONETYPEPERFILE
    docs: "[FileLanguage.cs.md](../../../docs/references/pwsh/catzc-base-languages/types/FileLanguage.cs.md)"
---
*/

// The insight line of the file's own comment.

using System;
```

```powershell
<#
---
catzc:
  edges:
    cites:
      - ADR-AUTO-TEST-QUALITYGATE
---
#>

Describe 'Get-WidgetFact' {
}
```

Without the comment delimiters the head is the front matter of a Markdown file, so one reader of the `catzc` block serves both and a tool
that knows one knows the other. The head is a comment, so the compiler ignores it. A blank line separates it from the file's own comment.
The comment engine keeps the head because its front matter opens with a head listed to keep, whatever the language's delimiters are.

### What the head holds

`The way out of the file, nothing the repository answers`

The rule codes a file cites are the one list a reader scans to learn which decisions bind the file, so the head shows them, rebuilt on every
run from the citations the file and its comment page make: a code the text no longer spells out no longer binds the file, and a list that
kept it would say something the file does not. The page is the file a reader opens next and costs a search to find, so it is one edge. The
test costs nothing to find, since the convention places it under `tests/`, and a body hash would change on every edit and tell a reader
nothing, so the head carries neither. The path, the role, the module and the visibility are each one question to a registry or the disk, so
a head that showed them would be a second statement of what the repository already says, and it would change on every move.

### Scope

`Every authored code and config file with a page or rules to cite`

The navigation head serves a reader who opens a code or config file, so its scope is the authored files whose carrier is a comment head or a
JSON property, and the head policy gives one only to a file with a `docs` or `cites` edge. The carrier registry already knows each
language's comment syntax, so the scope comes from it and no meta kind repeats a list of globs. The files the head would harm stay out
through `.gitattributes`: vendored code is someone else's, contract assets and fixtures are compared byte for byte, and generated files
carry the head their writer wrote ([ADR-REPO-FILEMETA-COMPOSEDFILES](file-meta.md#rule-adr-repo-filemeta-composedfiles)).

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

- A reader steps from a code file to its rules and its docs in one click, on GitHub or in an editor, and to its test by convention.
- The head changes only when the file's citations or its page change, never on an edit of the body alone.
- One registry, one engine and one naming convention serve Markdown and code, so a new kind of fact is a registry entry and a function.
- The head costs one blank line and a few comment lines on a file that has a page or rules to cite, none on any other, and changes no
  behaviour of the compiled type or the help text.
