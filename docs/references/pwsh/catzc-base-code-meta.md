# Catzc.Base.CodeMeta

The pure core of the code meta head: the leading comment of a C# type file, a PowerShell function file or any other code file whose carrier
is a comment head, holding the file's derived facts as the same front matter a Markdown file carries
([code-file-meta](../../drs/repository/code-file-meta.md)). The module reads no config and no file: every text, and the comment syntax of
the head, reaches it as a parameter, so it sits below [Catzc.Base.Config](catzc-base-config.md) on top of
[Catzc.Base.MarkdownMeta](catzc-base-markdown-meta.md), whose block reader and writer it reuses. The registry of meta kinds, the file-carrier
registry that names each file class's comment syntax, and the commands that read them live above `Catzc.Base.Config`.

## Responsibilities

| Responsibility   | Area       | Name                                                                              |
| ---------------- | ---------- | --------------------------------------------------------------------------------- |
| responsibility:1 | reading    | [Reading a text's head](#responsibility1--reading-a-texts-head)                   |
| responsibility:2 | imprinting | [Imprinting derived facts](#responsibility2--imprinting-derived-facts)            |
| responsibility:3 | pages      | [Locating a file's comment page](#responsibility3--locating-a-files-comment-page) |

### responsibility:1 — Reading a text's head

What a code text says about its own meta head: whether it has one, the sections and derived keys in the order written, the authored config
lines, the text that stays above it (a byte order mark, a shebang, an XML prolog or fixed preamble lines) and the rest of the text below it.
A comment directly under the head is not part of it, a block head that never closes is no head, and a comment that is not front matter with
a `catzc` block is no head either.

### responsibility:2 — Imprinting derived facts

Returning a text with its head written from the facts given, in one canonical form and in the order given, so the same facts always give the
same bytes. The head follows the language's anchor, a blank line separates it from the rest, the text's own line endings are kept, authored
config lines survive a rewrite, and no facts removes the head and its blank line. An old head the form lists to strip is removed with its
whole comment run before the head is written.

### responsibility:3 — Locating a file's comment page

Which page under docs/ holds a file's long comments, from the ordered source-folder to docs-folder maps of the comment-pages settings; the
first map that covers the file wins, and a file no map covers has no page. The settings reach it as a parameter, so every head writer and
every quality gate over comments finds the same page with the same call
([ADR-REPO-COMMENTS-COMMENTPAGEPLACE](../../drs/repository/comments-in-docs.md#rule-adr-repo-comments-commentpageplace)).

## What the module does

A code file has no front matter, but it has comments, and the leading comment is where a reader looks first. This module is that comment's
reader and writer, written as pure functions over text and three C# types: the head's comment syntax (`HeadForm`), where it may stand
(`HeadAnchor`) and the head itself (`CodeMetaHead`). Inside the comment the head is the front matter a Markdown file has, so the Markdown
meta block writes and reads it and a value is quoted only where YAML would read it back differently.

## Division

Each function belongs to one responsibility.

| Responsibility                                    | Function              |
| ------------------------------------------------- | --------------------- |
| responsibility:1 — Reading a text's head          | `Get-CodeMetaState`   |
| responsibility:2 — Imprinting derived facts       | `Format-CodeMetaHead` |
| responsibility:3 — Locating a file's comment page | `Get-CommentPage`     |
| config                                            | `comment-pages.yml`   |
