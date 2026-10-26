# pwsh/Base.Slides/Move-Diagram.ps1

The move of a diagram, or any file or folder, that keeps every relative link right: it stages the move with `git mv` and re-points the links
in and into the moved path.

## help

### synopsis

Moves a diagram's pair, or any other file or folder, with git mv and re-points every relative link in it and into it.

It moves with `git mv`, so a session that may not change git moves the pair on disk itself and re-points the links a `-DryRun` lists.

### description

A diagram is the pair `<article-folder>/.assets/<name>.drawio.yml` and `<name>.drawio.png`, named by either file or by its stem, so moving a
diagram moves both files; any other path moves as it is. The command stages the move with `git mv` and keeps every relative link right
([ADR-REPO-LINK-MARKDOWNRELATIVE](../../../drs/repository/markdown-links.md#rule-adr-repo-link-markdownrelative)): each link in a moved
`.md` file and in every page that links into the moved path is resolved to its repository path and recomputed from where the file now sits.
A page that stays in place keeps every other link as it wrote it. The source must hold a tracked file, and the destination must not exist,
so a move never merges into another diagram. It commits nothing.

### parameter `Path`

The repository-relative diagram (its `.drawio.yml`, its `.drawio.png` or its stem), or any other file or folder, to move.

### parameter `Destination`

The repository-relative path it moves to; its parent folders are created.

### parameter `RepositoryRoot`

The repository root both paths are relative to. Default: the loaded repository root.

### parameter `Kit`

The draw.io kit folder whose `configs/drawio.yml` keys each diagram's role by its stem; a moved stem is re-keyed there. Default:
`drawio_kit` of `slides.yml`.

### parameter `DryRun`

List the moves and the pages whose links would be re-pointed, and change nothing.

### parameter `PassThru`

Return the move: `From`, `To`, `Moves` (one `From`/`To` per file), `Pages` (the pages whose links were re-pointed) and `DryRun`.

### outputs

`[pscustomobject]` the move, with `-PassThru` only.

### example 1

```powershell
Move-Diagram docs/explanation/configuration/.assets/an-address-is-a-read-only-walk docs/explanation/design/.assets/an-address-is-a-read-only-walk -DryRun
```

## What moves

A diagram is the pair `<stem>.drawio.png` and `<stem>.drawio.yml`, named by either file or by its stem, and it moves whole; any other path,
a file or a folder, moves as it is.

## The kit's role entry

The kit's `drawio.yml` keys a diagram's role by its stem, and a repository without one has no legend. A stem's role entry follows the
diagram, so `drawio.yml` keeps naming it after the move; the kit's one editor re-keys it.

## Article-carried diagrams

A diagram is article-carried when it is a pair with no yml beside its png (its declaration is a block in an article). The block declares the
png below it only from a page beside its `.assets`, so it moves to the one page there that embeds the png. An image of the png is inline, or
a reference whose definition on the same page names it. A page whose links were re-pointed already has an entry; the block-moved text
replaces it, and a page with none is simply added.

## Formatting

A re-pointed link changes its line's length, so every rewritten page is formatted again, as the repository formats it.
