---
catzc:
  derived:
    path: docs/adr/repository/function-help.md
    kind: adr
    language: markdown
    track: docs
    body_sha: "3c30ae3e63b3"
    defines:
      - ADR-REPO-HELP#{1-5}
    adrs:
      - ADR-REPO-CODEMETA#{1,2}
      - ADR-REPO-FORMAT#8
    links:
      - docs/adr/repository/code-file-meta.md
      - docs/adr/repository/code-file-meta.md#rule-adr-repo-codemeta1
      - docs/adr/repository/code-file-meta.md#rule-adr-repo-codemeta2
      - docs/adr/repository/file-meta.md
      - docs/adr/repository/uniform-formatting.md#rule-adr-repo-format8
---

# ADR: Function help — the help of a PowerShell file is the config part of its meta head

## Rules: ADR-REPO-HELP

### Rule ADR-REPO-HELP:1

The help of a PowerShell function file or script is the `config` part of its meta head
([ADR-REPO-CODEMETA#1](code-file-meta.md#rule-adr-repo-codemeta1)), and the file carries no comment-based help block: no `.SYNOPSIS`,
`.DESCRIPTION`, `.PARAMETER`, `.INPUTS`, `.OUTPUTS`, `.EXAMPLE` or `.NOTES` section anywhere. The keys are `synopsis`, `description`,
`parameters`, `inputs`, `outputs`, `examples` and `notes`, always in that order.

- [The head holds the help](#the-head-holds-the-help)

### Rule ADR-REPO-HELP:2

A value is a string. A value of one line is a plain or a single-quoted YAML string, and a value of several lines is a literal block, so the
text is carried as written and the head never rewraps prose. `parameters` is a map from each parameter name, in the order of the `param`
block, to its string, and `examples` is a list of strings. The tooling reads these keys and never writes prose into them.

- [Strings, written once](#strings-written-once)

### Rule ADR-REPO-HELP:3

A citation is never part of the help text. The ADR codes a function rests on are the head's derived `adrs`
([ADR-REPO-CODEMETA#2](code-file-meta.md#rule-adr-repo-codemeta2)), and the page of a moved comment is a relative of the file, not a line of
its help. A line of the text made of nothing but a citation is reported.

- [Citations are derived](#citations-are-derived)

### Rule ADR-REPO-HELP:4

Four mismatches are reported and never rewritten: a parameter with no entry in `parameters`, an entry for a name the function does not
declare, an `outputs` string whose first type differs from `[OutputType]`, and a file with no `synopsis`.

- [Mismatches are reported](#mismatches-are-reported)

### Rule ADR-REPO-HELP:5

`Format-Code` checks rules 1 to 4 as an imprint step of the PowerShell language
([ADR-REPO-FORMAT#8](uniform-formatting.md#rule-adr-repo-format8)), and `Test-Formatting` fails a file the step reports. No command and no
check names the step. The step reads the file with the language's own parser, so a comment inside a string or a here-string is never
mistaken for help.

- [Hosted by Format-Code](#hosted-by-format-code)

## Context

A function's help was written as a comment block in the file, then moved in part to a comment page, with its citations at the tail of the
description and its parameters described once in a section and sometimes again above the parameter. Each of those places is text a tool has
to find by its position in a comment, and a comment is the one part of a file that no parser owns. The meta head is already front matter
that a parser reads ([file-meta](file-meta.md)), and it is where the facts about the file live, so the help belongs beside them.

## Decision

The help is data in the head, with one shape, and a check reads it as data.

### The head holds the help

`One place for what a file says about itself`

The synopsis, the description, the parameters, the outputs and the examples are keys of the head's `config` part, so a tool that reads the
head reads the help, and `Get-Help` is not the way to read a catzc function. A file has no comment block that a person must keep in step
with the head.

### Strings, written once

`Text as written`

A literal block keeps every line break, so a description with a list or an aligned table stays as it was written. A single-line string is
plain when YAML reads it back as the same string, and single-quoted otherwise, because a quoted string can hold any single line.

### Citations are derived

`The head already lists them`

The citations a function rests on are a list the formatter derives from the file and its page and keeps true, so a second copy in the
description would drift from it. A page link stands for prose moved out of the file and is derived the same way.

### Mismatches are reported

`A check, never a guess`

A missing entry, an entry for a name that is gone and a type that disagrees with `[OutputType]` each need a sentence only an author can
write, so they are findings.

### Hosted by Format-Code

`A configured step, not a new command`

The step is one line in the file-language registry, as the namespace step and the meta head are ([code-file-meta](code-file-meta.md)). It
runs after the formatter and the meta head.

### How this is enforced

- **`Format-Code`** checks the help through the `ps-help` step, and **`Test-Formatting`** fails any file it reports.
- **`Test-FileMeta`** fails a head whose derived part differs from what the formatter would write.
- **`PSProvideCommentHelp`** is off in the analyzer settings, because no function carries a comment-based help block.

## Consequences

- A function's help is read the same way as the rest of its meta, as data, and a diff of it shows only the text that changed.
- A parameter is described once, and a difference between the declaration and the description is a finding.
- `Get-Help` shows no catzc help, so the help is read from the head or the generated reference pages.
