---
catzc:
  derived:
    path: docs/adr/repository/comments-in-docs.md
    kind: adr
    body_sha: "141faf8267dc"
    adrs:
      - ADR-REPO-CODEMETA#1
      - ADR-REPO-LINK#9
---

# ADR: Comments in docs — one insight line in the file, the prose in its comment page

## Rules: ADR-REPO-COMMENTS

### Rule ADR-REPO-COMMENTS:1

A comment in a code or configuration file is at most one line of insight: what the code does not say itself — the invariant it keeps, the
order it depends on, the edge it guards, the reason a branch exists. A comment that needs more than one line of prose moves, verbatim, to
the file's **comment page**, and the file keeps in its place a **residue**: the insight line, then a line with the comment's ADR citations
and the docs link to its section (ADR-REPO-LINK#9). The comment-based help sections a reader and the help system need in place stay whole.

- [One line in the file](#one-line-in-the-file)

### Rule ADR-REPO-COMMENTS:2

The move loses nothing. Each moved comment becomes one section of the page, `## comment:<n>`, holding its lines exactly as they stood in the
file, comment markers and common indent removed, inside a fenced `text` block so no formatter rewrites them, under one line naming what the
comment annotated. A section's number is its address for life: a new comment takes the next number after the page's highest, a number is
never reused, and a section a person edits stays as edited.

- [A lossless move](#a-lossless-move)

### Rule ADR-REPO-COMMENTS:3

A file's comment page lives under `docs/references/`, at the place `comments.yml`'s `pages` map gives its source folder, and keeps the
file's own name and extension plus `.md`, so a page maps back to exactly one file. What moves — the file languages in scope, the shortest
comment that moves, the comment heads each language keeps — is configured there too, with its defaults declared once on the config type. A
kept head keeps only its own line, but a head the configuration lists to keep its run (`keep_run:`) keeps the whole contiguous run it opens,
so the meta head of a code file ([ADR-REPO-CODEMETA#1](code-file-meta.md#rule-adr-repo-codemeta1)) is never moved as prose, while prose
directly under a kept spell-checker line still is.

- [Where a page lives](#where-a-page-lives)

### Rule ADR-REPO-COMMENTS:4

The file with its comments inline is a generated view, never a second copy kept by hand: `Build-CommentView` writes it under `out/`, at the
file's repository path, from the file and its page. The view of an exported file equals the file before the move, and exporting an exported
file changes nothing.

- [The view](#the-view)

### Rule ADR-REPO-COMMENTS:5

The move is made by tool and checked by a gate: `Export-Comments` moves every long comment in scope, and `Format-Code` runs it as its
`comments` imprint step ([ADR-REPO-FORMAT#8](uniform-formatting.md#rule-adr-repo-format8)), so formatting a file also moves its prose.
`Format-Comments` keeps each insight line one line within the file's limit and free of links and of phrasings that state the obvious, and
`Test-Comments` fails on a long comment left in a file, a residue whose section is missing, a section no residue links, and a residue that
links another file's page. A comment page is marked as one in its meta block, whose `kind` is `comment-page`
([ADR-REPO-FILEMETA#1](file-meta.md#rule-adr-repo-filemeta1)).

- [How this is enforced](#how-this-is-enforced)

## Context

The repository's code carries a great deal of prose. Comment-based help descriptions run to several paragraphs, configuration files open
with a page of explanation before their first key, and a branch is often preceded by a paragraph on why it exists. That prose is valuable —
it is how a reader learns why the code is shaped as it is — but in the file it competes with the code for the reader's attention, and its
volume hides the one line in it that a reader most needs: the thing the code cannot say for itself.

Prose and code also change at different rates and are reviewed for different things. A long comment in a code file is reviewed as code,
formatted by a code formatter, and spell-checked line by line between statements; the same text in a Markdown page is reviewed as prose,
rendered on GitHub, and linked from the module's reference article.

### One line in the file

A file keeps, per long comment, the line that earns its place next to the code: a fact the code does not state. The rest of the comment is
not deleted — it moves. The insight line is followed by the comment's ADR citations, so the analyzer map, the rule tags, and `Format-Links`
still see every rule the comment invoked, and by the docs link, so a reader who wants the full prose is one click away.

The help sections a reader and `Get-Help` need in place stay whole: the synopsis, the examples, the inputs and outputs. A parameter's
description is one line or it moves like any other comment.

### A lossless move

A comment's text is the record of what its author meant, so the move is a bijection: every line that leaves the file lands in exactly one
section, and the view puts it back unchanged. The page keeps each comment in a fenced block because the Markdown formatter reflows prose;
without the fence the page would hold a reworded comment, and the round trip would no longer be exact.

Numbers are addresses. A residue names its section by number, and a link from elsewhere may name the section's anchor, so a number never
moves to another comment.

### Where a page lives

The page sits next to the module's reference article, in a folder named for the module, so the prose of a module's files is browsable in one
place and the article can link it. The mapping from source folders to page folders is configuration, the same shape as the README map,
because which folders carry comment pages is a per-repository choice ([configure-not-program](../principles/configure-not-program.md)).

### The view

A reader or an agent sometimes needs the file with its prose inline. The view supplies it without making it a source: it is written under
the gitignored output folder from the two sources that are reviewed — the file and its page — so it can never drift from them
([one-living-version](../principles/one-living-version.md)).

## Decision

A code or configuration file carries one insight line per comment; a comment longer than that moves, verbatim and numbered, to the file's
comment page under `docs/references/`, and the file keeps a residue with the insight, the citations, and a docs link. The full file is a
generated view under `out/`. Tools make the move and a gate holds it.

### How this is enforced

- **`Export-Comments`** (in `Catzc.Base.QualityGates`) — the one-way move, dry-run first, over every file in scope or the given paths.
  `Format-Code` runs it as the `comments` imprint step, over the same scope.
- **`Format-Comments`** — keeps each residue's insight line in shape and lists what needs a person.
- **`Build-CommentView`** — writes the annotated view under `out/`.
- **`Test-Comments`** — the gate over the pairing of residues and sections and over any long comment left in a file.
- **One engine** — every command drives the compiled `Catzc.Base.QualityGates.CommentEngine`, which finds comments through `CommentLexer`,
  the one place that knows each language's comment syntax; `comments.yml` holds the configured choices.
- **`Test-Links`** — checks every docs link: its page exists and holds its own section (ADR-REPO-LINK#9).

## Consequences

- Code files shrink to code and the one line per comment that explains what the code does not; the prose is read as prose, on GitHub, beside
  the module's reference article.
- `Get-Help` shows the insight line and a link where it used to show paragraphs; the view under `out/` is where the full text is read in
  place.
- A long comment written in a file fails the gate until it is exported, so the prose always ends up in one place.
- An insight line produced by the tool is the comment's first sentence, provisional until someone rewrites it to say what the code does not.
