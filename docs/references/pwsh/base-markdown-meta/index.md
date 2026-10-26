# Catzc.Base.MarkdownMeta

The pure core of the Markdown meta block: the one reserved `catzc` front-matter key of a tracked Markdown file, at the top level or nested
at the key path its carrier declares, its derived facts and its authored config contributions
([file-meta](../../../drs/repository/file-meta.md)). The module reads no config and no file: every text and every declaration reaches it as
a parameter, so it sits below [Catzc.Base.Config](../base-config/index.md), which can then call it when it gathers config contributions. The
registry of meta kinds, the processors and the `Format-FileMeta` and `Test-FileMeta` commands live above `Catzc.Base.Config`, in the module
that reads the registry.

## Responsibilities

| Responsibility   | Area       | Name                                                                   |
| ---------------- | ---------- | ---------------------------------------------------------------------- |
| responsibility:1 | reading    | [Reading a text's meta](#responsibility1--reading-a-texts-meta)        |
| responsibility:2 | imprinting | [Imprinting derived facts](#responsibility2--imprinting-derived-facts) |
| responsibility:3 | stripping  | [Leaving the meta out](#responsibility3--leaving-the-meta-out)         |
| responsibility:4 | wrapping   | [Wrapping generated prose](#responsibility4--wrapping-generated-prose) |

### responsibility:1 — Reading a text's meta

What a Markdown text says about its own meta block: whether it has front matter and a block, whether a parent key on the block's key path
can hold one at all, its body and the hash of that body, the keys directly under `catzc`, under `immutable` and the names of the edges under
`edges`, and the authored config lines as written. The hash drops the blank line that separates written front matter from the body, so
imprinting never changes the hash it records.

### responsibility:2 — Imprinting derived facts

Returning a text with its `immutable` and `edges` parts written from the facts and edges given, in one canonical form and in the order
given, so the same facts always give the same bytes. The authored `config` part and every other byte of the text are kept, and the line
endings are the text's own.

### responsibility:3 — Leaving the meta out

Returning a text without its front matter, for a copy that carries the content but not the file's meta, such as a generated README.

### responsibility:4 — Wrapping generated prose

The one way generated markdown wraps its prose: a paragraph or list item filled at the 140-column width the way the formatter fills it, so a
page a generator writes is the page the formatter leaves alone
([uniform-formatting](../../../drs/repository/uniform-formatting.md#rule-adr-repo-format-generatedformatted)). Every generator that writes
markdown wraps through it, in any module.

## What the module does

A Markdown file's front matter is shared with other tools, so the tooling owns exactly one key in it and touches nothing else. This module
is that one key's reader and writer, written as pure functions over text and a handful of C# types, so every behaviour is tested on strings
alone and the reader of configs can call it without depending on the module that reads the meta-kind registry.

## Division

Each function belongs to one responsibility.

| Responsibility                              | Function                     |
| ------------------------------------------- | ---------------------------- |
| responsibility:1 — Reading a text's meta    | `Get-MarkdownMetaState`      |
| responsibility:2 — Imprinting derived facts | `Format-MarkdownMetaBlock`   |
| responsibility:3 — Leaving the meta out     | `Remove-MarkdownFrontMatter` |
| responsibility:4 — Wrapping generated prose | `Format-MarkdownParagraph`   |
