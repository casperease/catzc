# ADR: Comments in docs — a file keeps one line of insight per comment, the rest lives in its comment page

## Rules: ADR-REPO-COMMENTS

### Rule ADR-REPO-COMMENTS-ONELINEOFINSIGHT

A comment in a code or configuration file is at most one line of insight: what the code does not say itself — the invariant it keeps, the
order it depends on, the edge it guards, the reason a branch exists. A comment that needs more than one line of prose moves, verbatim, to
the file's **comment page** and leaves at most one authored line of **algorithmical insight** at its place
([ADR-REPO-COMMENTS-CLUESNOTNARRATION](#rule-adr-repo-comments-cluesnotnarration)), short enough to stay below the export threshold so the
exporter never takes it again; it leaves no marker and no link. The comment's rule citations move with the rest of its prose and are found
there. The way from a file to its page is the `pages` map of the `comment-pages` config
([ADR-REPO-COMMENTS-COMMENTPAGEPLACE](#rule-adr-repo-comments-commentpageplace)), so it is derived from the file's path, never a line of
code. The file's head shows that way as its `docs` edge, a link for a reader
([ADR-REPO-FILEMETA-HEADPOLICY](file-meta.md#rule-adr-repo-filemeta-headpolicy),
[ADR-REPO-FILEMETA-FEWLINKS](file-meta.md#rule-adr-repo-filemeta-fewlinks)), and no tool reads it back
([ADR-REPO-FILEMETA-NOREADBACK](file-meta.md#rule-adr-repo-filemeta-noreadback)).

- [One line of insight in place](#one-line-of-insight-in-place)

### Rule ADR-REPO-COMMENTS-CLUESNOTNARRATION

A comment in a code or configuration file is an **algorithmical insight**: an authored clue that gives the next reader a higher-level view
of the code in its context, never a narration of the code and never a diagnostic (no generated note, finding or tool output). It earns its
line only when it is **relevant** to someone reading that place: what the code cannot say for itself, such as why it is shaped so, what
would break if it changed, or what a parameter's value means in practice. It is **not tied to the current implementation**: it does not
restate what the line does, does not record what the code was, is becoming or should become, and does not carry a to-do, a history or a
habit-dropped label. A comment that would go stale the moment the code is rewritten in another way is not a clue, and it is not written.

- [Clues, not narration](#clues-not-narration)

### Rule ADR-REPO-COMMENTS-MOVELOSESNOTHING

The move loses nothing. Each moved comment becomes one section of the page, `## comment:<n>`, holding its lines exactly as they stood in the
file, comment markers and common indent removed, inside a fenced `text` block so no formatter rewrites them. Above the fence one line names
where the comment stood: the code line it sat above (and which occurrence of that line, when the file repeats it), or the end of the file,
and the comment marker it was written with. A section's number is its address for life: a new comment takes the next number after the page's
highest, a number is never reused, and a section a person edits stays as edited.

- [A lossless move](#a-lossless-move)

### Rule ADR-REPO-COMMENTS-COMMENTPAGEPLACE

A file's comment page lives under `docs/references/`, at the place the `pages` map of the `comment-pages` config gives its source folder,
and keeps the file's own name and extension plus `.md`, so a page maps back to exactly one file. What moves — the file languages in scope,
the shortest comment that moves, the comment heads each language keeps — is configured in `comments.yml`, each config with its defaults
declared once on its config type. A kept head keeps only its own line, but a head the configuration lists to keep its run (`keep_run:`)
keeps the whole contiguous run it opens, and the front matter of a block comment that opens with such a head is kept whole, so the meta head
of a code file ([ADR-REPO-CODEMETA-CODEFILEHEAD](code-file-meta.md#rule-adr-repo-codemeta-codefilehead)) is never moved as prose, while
prose directly under a kept spell-checker line still is. A delimited block that holds a kept head, such as the comment-based help a script
analyzer rule carries, stays whole.

- [Where a page lives](#where-a-page-lives)

### Rule ADR-REPO-COMMENTS-INLINEVIEWGENERATED

The file with its comments inline is a generated view, never a second copy kept by hand: `Build-CommentView` writes it under `out/`, at the
file's repository path, from the file and its page, putting every section back above the code line it names as line comments. The view of an
exported file reads as the file before the move, and exporting an exported file changes nothing.

- [The view](#the-view)

### Rule ADR-REPO-COMMENTS-MOVEDBYTOOL

The move is made by tool and checked by a gate: `Export-Comments` moves every long comment in scope, and `Format-Code` runs it as its
`comments` imprint step ([ADR-REPO-FORMAT-CONFIGUREDFORMATTERS](uniform-formatting.md#rule-adr-repo-format-configuredformatters)), so
formatting a file also moves its prose. `Test-Comments` fails on a long comment left in a file and on a section whose code line the file no
longer has. A comment page is told as one by its path, which the file-kinds registry names `comment-page`
([ADR-REPO-FILEMETA-ROLE](file-meta.md#rule-adr-repo-filemeta-role)), never by its head.

- [How this is enforced](#how-this-is-enforced)

### Rule ADR-REPO-COMMENTS-PAGEISAUTHORED

A comment page is an authored file. Its `## comment:<n>` sections are the exporter's to append and the author's to edit
([ADR-REPO-COMMENTS-MOVELOSESNOTHING](#rule-adr-repo-comments-movelosesnothing)), and the page of a PowerShell function file or script also
holds the file's help in a `## help` section ([ADR-REPO-HELP-HELPONCOMMENTPAGE](function-help.md#rule-adr-repo-help-helponcommentpage)),
which is the author's alone: `Export-Comments` never writes, moves or reorders it, and `Test-Comments` checks only the comment sections.

- [An authored page](#an-authored-page)

## Context

The repository's code carries a great deal of prose. Configuration files open with a page of explanation before their first key, and a
branch is often preceded by a paragraph on why it exists. That prose is valuable — it is how a reader learns why the code is shaped as it is
— but in the file it competes with the code for the reader's attention.

Prose and code also change at different rates and are reviewed for different things. A long comment in a code file is reviewed as code,
formatted by a code formatter, and spell-checked line by line between statements; the same text in a Markdown page is reviewed as prose,
rendered on GitHub, and linked from the module's reference article.

### One line of insight in place

A marker in the code, even a short one, is still something the code carries on behalf of the prose: a line to keep in step, to keep within a
length, to keep unlinked from the wrong page. The configured page map already turns the file's path into its page's path, so no pointer is
needed anywhere. What a reader at that place does need is the gist: one authored line that says why the code is shaped so, written as a
clue, not a summary of the page. Being one line, it is below the export threshold, so the exporter leaves it where it stands and the page
keeps the full prose. The page does the pairing: each section says which code line its comment sat above.

The price is that a section is addressed by the line beneath it, so editing that line can orphan the section. `Test-Comments` reports the
orphan, and the fix is the same one-line edit of the section's context line a reviewer would make by hand.

### Clues, not narration

Code already says what it does; a comment that repeats it is noise the reader has to read past, and one that describes the code as it stands
today is wrong the day the code changes. The comments worth keeping are the ones a reader could not recover from the code: the reason behind
a choice, the trap a change would fall into, the meaning of a value. Those stay true as long as the reason does, whatever the implementation
becomes. History belongs in `git log` and plans in `.claude/plans`, so a comment never carries either.

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

### An authored page

Once a comment has moved, the page is the only place its text lives, and an author edits it there, so the page is a source and not a copy:
nothing regenerates it and nothing could. The exporter only adds new sections at the end. A function's help is prose of the same sort,
written by an author about one file, so it lives on the same page in a section of its own, and the two owners never touch each other's
sections.

## Decision

A code or configuration file carries only comments of one line; a longer comment moves, verbatim and numbered, to the file's comment page
under `docs/references/` and leaves nothing behind, and the file's path names the page. The full file is a generated view under `out/`.
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
