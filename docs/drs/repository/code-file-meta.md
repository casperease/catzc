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

An authored code or config file's head is the **navigation head**, and it holds exactly `with_body_sha` under `immutable` and the edges
under `edges`: `cites`, the ADR codes that bind the file, sorted and without duplicates, each a rule code or a bare domain-level code;
`docs`, the link to its comment page by its repository-relative path; `test`, the file that tests it; and, on a test, `code`, the file it
tests ([ADR-REPO-FILEMETA-FEWLINKS](file-meta.md#rule-adr-repo-filemeta-fewlinks)). Each edge is left out when it has no target. `cites` is
each code the file and its comment page cite that the ADR index registers, so a fixture code or a placeholder named in prose is no citation,
derived on every run and never read back from the head ([ADR-REPO-FILEMETA-NOREADBACK](file-meta.md#rule-adr-repo-filemeta-noreadback)).
`with_body_sha` is the hash of the body below the head, and its cost is accepted: it changes on every edit of the body, so two concurrent
edits of one file also meet on that line. Every place fact, the path, the role, the language, the track, the module and the visibility, is
derived on demand and never written into the head. A code head has no `config` part: a code file's prose, its help included, lives on its
comment page ([ADR-REPO-HELP-HELPONCOMMENTPAGE](function-help.md#rule-adr-repo-help-helponcommentpage)). A generated code file carries the
generated-file head instead ([ADR-REPO-FILEMETA-COMPOSEDFILES](file-meta.md#rule-adr-repo-filemeta-composedfiles)).

- [What the head holds](#what-the-head-holds)

### Rule ADR-REPO-CODEMETA-SAMEENGINE

The head is imprinted by the same engine, from the same registry, as a Markdown block
([ADR-REPO-FILEMETA-METAKIND](file-meta.md#rule-adr-repo-filemeta-metakind),
[ADR-REPO-FILEMETA-IMPRINTEDPARTS](file-meta.md#rule-adr-repo-filemeta-imprintedparts)): a kind is a registry entry, and its processor is a
function found by convention. The scope is the variant: when `file_heads.code` is `minimal`
([ADR-REPO-VARIANT-FILEHEADS](repo-variants.md#rule-adr-repo-variant-fileheads)), every authored file whose carrier is a comment head or a
JSON property carries the navigation head, tests and configs included, less the classes `.gitattributes` exempts
([ADR-REPO-FILEMETA-KINDSCOPE](file-meta.md#rule-adr-repo-filemeta-kindscope)); when it is `none`, no authored file carries one, and the
engine strips a head a file holds. The kinds that fill the head select no files of their own, so they apply to every file the policy gives a
head.

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

A C# type file and a PowerShell function file each rest on rules, have a page that holds their long comments, and have a test that proves
them. A reader who opens the file on GitHub or in an editor wants those one step away, and finding each costs a search. Every other fact
about the file, its path, its module, its tier, the repository already knows and answers on demand.

A Markdown file solves a similar need with a block in its front matter ([file-meta](file-meta.md)). Code has no front matter, but it has
comments, and a leading comment run is the place a reader looks first.

## Decision

An authored code file's edges sit in a navigation head at the top of the file, written by the formatter, in the one registry that already
serves Markdown, and a repo-wide variant switches it on or off. The head is small, because every key in it is a key that can drift.

### The head is front matter in a comment

`One parser for every file, plain comments in the language`

```csharp
/*
---
catzc:
  immutable:
    with_body_sha: 3fa91c0d2b7e
  edges:
    cites:
      - ADR-BCL-TYPES-ONETYPEPERFILE
    docs: "[FileLanguage.cs.md](docs/references/pwsh/catzc-base-languages/types/FileLanguage.cs.md)"
    test: pwsh/Catzc.Base.Languages/tests/types/FileLanguage.Tests.ps1
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
    with_body_sha: 9b04e7a1c3d2
  edges:
    code: pwsh/Catzc.Base.QualityGates/private/Get-WidgetFact.ps1
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

The ADR codes a file cites are the one list a reader scans to learn which decisions bind the file, so the head shows them, rebuilt on every
run from the citations the file and its comment page make: a code the text no longer spells out no longer binds the file, and a list that
kept it would say something the file does not. The page and the test are the two files a reader opens next, and a test's next file is the
code it proves, so each is one edge. The body hash stamps the text the head was written for, and its price is that every edit changes it, so
two concurrent edits of one file also meet on that line; git merges the body, and the next imprint writes the hash again. The path, the
role, the module and the visibility are each one question to a registry or the disk, so a head that showed them would be a second statement
of what the repository already says, and it would change on every move.

### Scope

`Every authored code and config file, as the variant says`

The navigation head serves a reader who opens a code or config file, so its scope is the authored files whose carrier is a comment head or a
JSON property, and the variant decides whether they carry it at all. The carrier registry already knows each language's comment syntax, so
the scope comes from it and no meta kind repeats a list of globs. The files the head would harm stay out through `.gitattributes`: vendored
code is someone else's, contract assets and fixtures are compared byte for byte, and generated files carry the head their writer wrote
([ADR-REPO-FILEMETA-COMPOSEDFILES](file-meta.md#rule-adr-repo-filemeta-composedfiles)).

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

- A reader steps from a code file to its rules, its docs and its test, or from a test to its code, in one click, on GitHub or in an editor.
- The head changes when the file's citations or companions change, and its body hash on every edit, which is the one cost it carries.
- One registry, one engine and one naming convention serve Markdown and code, so a new kind of fact is a registry entry and a function.
- The head costs one blank line and a few comment lines per file and changes no behaviour of the compiled type or the help text, and the
  variant removes it from every authored file in one switch.
