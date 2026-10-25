# pwsh/Catzc.Base.QualityGates/private/Get-ConventionEdge.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Derives the convention relations of a set of tracked paths: the relations a declaration implies and no file writes.

### description

Each relation is derived from its declaration on every call, never read from a file
([ADR-REPO-LINKS-CONVENTIONSAREDERIVED](../../../../drs/repository/links-in-repository.md#rule-adr-repo-links-conventionsarederived)):

- A test points at its subject: the file of its own unit, outside `tests/`, whose name without extension is the test's stem. A test under
  `tests/types/` finds its type the same way. A test with no such file has no relation.
- A file points at its comment page, where the comment-pages config's `pages` map places one and that page is among the paths.
- A module points at each module it declares as a dependency (`Get-ModuleDependencyEdges -Declared`). The module's folder stands for it,
  because no tracked file does; a group name in the dependencies is no module and has no relation.

Every relation is a `Convention` edge with no line or column of its own.

### parameter `Path`

Repository-relative, '/'-separated tracked paths: the files the relations may join.

### outputs

`[Catzc.Base.QualityGates.LinkEdge[]]`

## comment:1

Above `$commentPages = Get-Config -Config comment-pages`, written with `#`.

```text
A file points at its comment page, where the pages map places one and it is tracked.
The config's own PageFor is what Get-CommentPage asks; called directly, it costs no function call per file.
```

## comment:2

Above `$files = @($Path | ForEach-Object { $_.Replace('\', '/') } | Select-Object...`, written with `#`.

```text
Each relation is derived from the declaration that implies it, never read from a file
([ADR-REPO-LINKS-CONVENTIONSAREDERIVED](/docs/drs/repository/links-in-repository.md#rule-adr-repo-links-conventionsarederived)).
```
