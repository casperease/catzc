---
catzc:
  derived:
    path: docs/references/automation/catzc-base-markdownmeta.md
    kind: reference
    language: markdown
    track: docs
    body_sha: "0de04e1f42fa"
    links:
      - docs/adr/repository/file-meta.md
      - docs/references/automation/catzc-base-config.md
---

# Catzc.Base.MarkdownMeta

The pure core of the Markdown meta block: the one reserved `catzc` front-matter key of a tracked Markdown file, its derived facts and its
authored config contributions ([file-meta](../../adr/repository/file-meta.md)). The module reads no config and no file: every text and every
declaration reaches it as a parameter, so it sits below [Catzc.Base.Config](catzc-base-config.md), which can then call it when it gathers
config contributions. The registry of meta kinds, the processors and the `Format-FileMeta` and `Test-FileMeta` commands live above
`Catzc.Base.Config`, in the module that reads the registry.

## Responsibilities

| Responsibility   | Area       | Name                                                                   |
| ---------------- | ---------- | ---------------------------------------------------------------------- |
| responsibility:1 | reading    | [Reading a text's meta](#responsibility1--reading-a-texts-meta)        |
| responsibility:2 | imprinting | [Imprinting derived facts](#responsibility2--imprinting-derived-facts) |
| responsibility:3 | stripping  | [Leaving the meta out](#responsibility3--leaving-the-meta-out)         |

### responsibility:1 — Reading a text's meta

What a Markdown text says about its own meta block: whether it has front matter and a block, its body and the hash of that body, the keys
directly under `catzc` and under `derived`, and the authored config lines as written. The hash drops the blank line that separates written
front matter from the body, so imprinting never changes the hash it records.

### responsibility:2 — Imprinting derived facts

Returning a text with its `derived` part written from the facts given, in one canonical form and in the order given, so the same facts
always give the same bytes. The authored `config` part and every other byte of the text are kept, and the line endings are the text's own.

### responsibility:3 — Leaving the meta out

Returning a text without its front matter, for a copy that carries the content but not the file's meta, such as a generated README.

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
