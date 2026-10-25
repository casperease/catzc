# pwsh/Catzc.Base.Slides/Move-Diagram.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Moves a diagram's pair, or any other file or folder, with git mv and re-points every relative link in it and into it.

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

## comment:1

Above `$pair = $from -cmatch '\.drawio\.(png|yml)$' -or -not (Test-Path -LiteralPath...`, written with `#`.

```text
A diagram is the pair <stem>.drawio.png and <stem>.drawio.yml, named by either file or by its stem, and it moves whole; any other
path, a file or a folder, moves as it is.
```

## comment:2

Above `$kitConfig = [Catzc.Base.Slides.DrawioKit]::new($root, $Kit).Config`, written with `#`.

```text
The kit's drawio.yml keys a diagram's role by its stem; a repository without one has no legend. A diagram is article-carried when it
is a pair with no yml beside its png (its declaration is a block in an article).
```
