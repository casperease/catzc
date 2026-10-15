---
catzc:
  derived:
    path: docs/adr/repository/function-help.md
    kind: adr
    body_sha: "0c6470fe90a3"
    defines:
      - ADR-REPO-HELP#1
      - ADR-REPO-HELP#2
      - ADR-REPO-HELP#3
      - ADR-REPO-HELP#4
      - ADR-REPO-HELP#5
    adrs:
      - ADR-REPO-FORMAT#8
      - ADR-REPO-LINK#3
      - ADR-REPO-LINK#9
    links:
      - docs/adr/repository/code-file-meta.md
      - docs/adr/repository/markdown-links.md#rule-adr-repo-link3
      - docs/adr/repository/markdown-links.md#rule-adr-repo-link9
      - docs/adr/repository/uniform-formatting.md#rule-adr-repo-format8
---

# ADR: Function help — one normal form for the help block of a PowerShell function file

## Rules: ADR-REPO-HELP

### Rule ADR-REPO-HELP:1

The help block of a function file keeps its sections in one order: `.SYNOPSIS`, `.DESCRIPTION`, one `.PARAMETER` per parameter in the order
of the `param` block, `.INPUTS`, `.OUTPUTS`, `.EXAMPLE`, `.NOTES`. The text of each section is never rewritten when the order is restored.

- [The sections have one order](#the-sections-have-one-order)

### Rule ADR-REPO-HELP:2

The ADR citations of a function live in one place: its meta head, whose `adrs` list the file and its comment page derive
([ADR-REPO-CODEMETA#2](code-file-meta.md#rule-adr-repo-codemeta2)). The help block carries none: a parenthesised citation leaves `.SYNOPSIS`,
which the list view of `Get-Help` shows, and a line made of citations leaves `.DESCRIPTION`. The docs link of a moved comment
([ADR-REPO-LINK#9](markdown-links.md#rule-adr-repo-link9)) stays on its own line at the tail of the description. A citation in a sentence of
the synopsis is reported, never rewritten.

- [Citations live in the head](#citations-live-in-the-head)

### Rule ADR-REPO-HELP:3

A parameter is described once, in its `.PARAMETER` section. An inline comment above a parameter is dropped when it says the same as the
section, and becomes the missing section when the parameter has none. When both exist and differ, or when the inline comment carries the
docs link of a moved comment, the file is reported for a person to settle, because authored prose is never rewritten to remove a difference.

- [A parameter is described once](#a-parameter-is-described-once)

### Rule ADR-REPO-HELP:4

Three mismatches are reported and never rewritten: a parameter with no `.PARAMETER` section, a `.PARAMETER` section for a name the function
does not declare, and an `.OUTPUTS` section whose first type differs from `[OutputType]`.

- [Mismatches are reported](#mismatches-are-reported)

### Rule ADR-REPO-HELP:5

`Format-Code` writes rules 1 to 3 as an imprint step of the PowerShell language
([ADR-REPO-FORMAT#8](uniform-formatting.md#rule-adr-repo-format8)), and `Test-Formatting` fails a file the step would change or report. No
command and no check names the step. The step reads the file with the language's own parser, so a comment inside a string or a here-string
is never mistaken for help.

- [Hosted by Format-Code](#hosted-by-format-code)

## Context

A function's help is read in three places: `Get-Help`, the file itself and the comment page that holds prose moved out of the file. Each
place shows a fact the function states once, so a fact that is written twice, as an inline comment and a `.PARAMETER` section, can differ
without any check noticing, and a citation placed in the synopsis shows up in every list of commands.

## Decision

The help block has one normal form, written by the formatter wherever the rewrite cannot change what an author meant, and reported wherever
it could.

### The sections have one order

`Same order in every file`

A reader who knows where `.PARAMETER` sits finds it in every file, and a diff of two functions lines up. Only the position of a section
changes, so `Get-Help` shows the same text before and after.

### Citations sit at the tail of the description

`One place for what the function rests on`

The description says what the function does, and the citations say which rules it rests on, so the citations close the description. The
synopsis is one line shown in lists, where a citation is noise. Sorting and removing duplicates make the list stable, so two edits that add
a citation to one function do not conflict on its order. The docs link stays with the citations of its section, because it stands for the
prose that was moved there.

### A parameter is described once

`The section is the one place`

The `.PARAMETER` section is what `Get-Help -Parameter` shows, so it is the place. An inline comment that repeats it is dropped, and an
inline comment with no section is the section written in the wrong place, so it moves there with its text unchanged. When the two differ,
only the author knows which is right, so the file is reported and left alone.

### Mismatches are reported

`A check, never a guess`

A missing section, a section for a name that is gone and a type that disagrees with `[OutputType]` each need a sentence only an author can
write, so they are findings.

### Hosted by Format-Code

`A configured step, not a new command`

The step is one line in the file-language registry, as the namespace step and the meta head are ([code-file-meta](code-file-meta.md)). It
runs after the formatter and the meta head, and `Format-Links` keeps the line limit of the citation lines it writes.

### How this is enforced

- **`Format-Code`** writes the normal form through the `ps-help` step, and **`Test-Formatting`** fails any file it would change or report.
- **`Test-Links`** checks every code link the step writes.
- **`Test-Comments`** checks the citation and docs-link lines of a moved comment.

## Consequences

- A function's help reads the same in every file, and its citations are one sorted list at the end of the description.
- A parameter's description lives in one place, and a difference between two descriptions is visible instead of silent.
- The step moves and orders text and never writes prose, so a diff of the help block shows only moved lines.
