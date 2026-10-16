---
catzc:
  immutable:
    with_body_sha: da8f190cff2b
    path: docs/adr/repository/comments-in-docs.md
    folder: docs/adr/repository
    name: comments-in-docs
    filetype: md
    kind: adr
    language: markdown
    track: docs
    tracktype: documentation
  edges:
    defines:
      - ADR-REPO-COMMENTS#{1-5}
    cites:
      - ADR-REPO-CODEMETA#{1,2}
      - ADR-REPO-FILEMETA#{1,10}
      - ADR-REPO-FORMAT#8
    links:
      - docs/adr/principles/configure-not-program.md
      - docs/adr/principles/one-living-version.md
      - docs/adr/repository/code-file-meta.md#rule-adr-repo-codemeta1
      - docs/adr/repository/file-meta.md#rule-adr-repo-filemeta1
      - docs/adr/repository/uniform-formatting.md#rule-adr-repo-format8
---

# ADR: Comments in docs — only a one-line comment stays in the file, the rest lives in its comment page

## Rules: ADR-REPO-COMMENTS

### Rule ADR-REPO-COMMENTS:1

A comment in a code or configuration file is at most one line of insight: what the code does not say itself — the invariant it keeps, the
order it depends on, the edge it guards, the reason a branch exists. A comment that needs more than one line of prose moves, verbatim, to
the file's **comment page** and leaves **nothing** in the file: no marker, no insight line, no link. The comment's ADR citations move with
the rest of its prose, and the file's meta head lists them (ADR-REPO-CODEMETA#2). The file's meta head names the page as its
`relatives.page` (ADR-REPO-FILEMETA#10), so the way from a file to its prose is derived front matter, never a line of code.

- [Nothing in the file](#nothing-in-the-file)

### Rule ADR-REPO-COMMENTS:2

The move loses nothing. Each moved comment becomes one section of the page, `## comment:<n>`, holding its lines exactly as they stood in the
file, comment markers and common indent removed, inside a fenced `text` block so no formatter rewrites them. Above the fence one line names
where the comment stood: the code line it sat above (and which occurrence of that line, when the file repeats it), or the end of the file,
and the comment marker it was written with. A section's number is its address for life: a new comment takes the next number after the page's
highest, a number is never reused, and a section a person edits stays as edited.

- [A lossless move](#a-lossless-move)

### Rule ADR-REPO-COMMENTS:3

A file's comment page lives under `docs/references/`, at the place `comments.yml`'s `pages` map gives its source folder, and keeps the
file's own name and extension plus `.md`, so a page maps back to exactly one file. What moves — the file languages in scope, the shortest
comment that moves, the comment heads each language keeps — is configured there too, with its defaults declared once on the config type. A
kept head keeps only its own line, but a head the configuration lists to keep its run (`keep_run:`) keeps the whole contiguous run it opens,
and the front matter of a block comment that opens with such a head is kept whole, so the meta head of a code file
([ADR-REPO-CODEMETA#1](code-file-meta.md#rule-adr-repo-codemeta1)) is never moved as prose, while prose directly under a kept spell-checker
line still is. A delimited block that holds a kept head, such as the comment-based help a script analyzer rule carries, stays whole.

- [Where a page lives](#where-a-page-lives)

### Rule ADR-REPO-COMMENTS:4

The file with its comments inline is a generated view, never a second copy kept by hand: `Build-CommentView` writes it under `out/`, at the
file's repository path, from the file and its page, putting every section back above the code line it names as line comments. The view of an
exported file reads as the file before the move, and exporting an exported file changes nothing.

- [The view](#the-view)

### Rule ADR-REPO-COMMENTS:5

The move is made by tool and checked by a gate: `Export-Comments` moves every long comment in scope, and `Format-Code` runs it as its
`comments` imprint step ([ADR-REPO-FORMAT#8](uniform-formatting.md#rule-adr-repo-format8)), so formatting a file also moves its prose.
`Test-Comments` fails on a long comment left in a file and on a section whose code line the file no longer has. A comment page is marked as
one in its meta block, whose `kind` is `comment-page` ([ADR-REPO-FILEMETA#1](file-meta.md#rule-adr-repo-filemeta1)).

- [How this is enforced](#how-this-is-enforced)

## Context

The repository's code carries a great deal of prose. Configuration files open with a page of explanation before their first key, and a
branch is often preceded by a paragraph on why it exists. That prose is valuable — it is how a reader learns why the code is shaped as it is
— but in the file it competes with the code for the reader's attention.

Prose and code also change at different rates and are reviewed for different things. A long comment in a code file is reviewed as code,
formatted by a code formatter, and spell-checked line by line between statements; the same text in a Markdown page is reviewed as prose,
rendered on GitHub, and linked from the module's reference article.

### Nothing in the file

A marker in the code, even a short one, is still something the code carries on behalf of the prose: a line to keep in step, to keep within a
length, to keep unlinked from the wrong page. The file's meta head already carries derived facts about the file, so the pointer to the page
is one more of them (`relatives.page`), computed from the configured page map, and the code keeps only code and the comments that fit on one
line. The page does the pairing instead: each section says which code line its comment sat above.

The price is that a section is addressed by the line beneath it, so editing that line can orphan the section. `Test-Comments` reports the
orphan, and the fix is the same one-line edit of the section's context line a reviewer would make by hand.

### A lossless move

A comment's text is the record of what its author meant, so the move is a bijection: every line that leaves the file lands in exactly one
section, and the view puts it back unchanged. The page keeps each comment in a fenced block because the Markdown formatter reflows prose;
without the fence the page would hold a reworded comment, and the round trip would no longer be exact.

Numbers are addresses. A link from elsewhere may name a section's anchor, so a number never moves to another comment.

### Where a page lives

The page sits next to the module's reference article, in a folder named for the module, so the prose of a module's files is browsable in one
place and the article can link it. The mapping from source folders to page folders is configuration, the same shape as the README map,
because which folders carry comment pages is a per-repository choice ([configure-not-program](../principles/configure-not-program.md)).

### The view

A reader or an agent sometimes needs the file with its prose inline. The view supplies it without making it a source: it is written under
the gitignored output folder from the two sources that are reviewed — the file and its page — so it can never drift from them
([one-living-version](../principles/one-living-version.md)).

## Decision

A code or configuration file carries only comments of one line; a longer comment moves, verbatim and numbered, to the file's comment page
under `docs/references/` and leaves nothing behind, and the file's meta head names the page. The full file is a generated view under `out/`.
Tools make the move and a gate holds it.

### How this is enforced

- **`Export-Comments`** (in `Catzc.Base.QualityGates`) — the one-way move, dry-run first, over every file in scope or the given paths.
  `Format-Code` runs it as the `comments` imprint step, over the same scope.
- **`Build-CommentView`** — writes the annotated view under `out/`.
- **`Test-Comments`** — the gate over any long comment left in a file and over sections whose code line is gone.
- **One engine** — every command drives the compiled `Catzc.Base.QualityGates.CommentEngine`, which finds comments through `CommentLexer`,
  the one place that knows each language's comment syntax; `comments.yml` holds the configured choices.

## Consequences

- Code files shrink to code and one-line comments; the prose is read as prose, on GitHub, beside the module's reference article.
- The view under `out/` is where the full text is read in place.
- A long comment written in a file fails the gate until it is exported, so the prose always ends up in one place.
- Editing the code line under a moved comment orphans its section until the section's context line follows the edit.
