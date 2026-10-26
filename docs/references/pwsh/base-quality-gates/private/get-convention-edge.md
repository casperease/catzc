# pwsh/Base.QualityGates/private/Get-ConventionEdge.ps1

Derives the convention relations of a set of tracked paths for the link tools: the relations a declaration implies and no file writes. It is
the one place a test, a comment page or a module dependency becomes an edge.

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

## derived on every call

Each relation is derived from the declaration that implies it, never read from a file
([ADR-REPO-LINKS-CONVENTIONSAREDERIVED](../../../../drs/repository/links-in-repository.md#rule-adr-repo-links-conventionsarederived)). A
moved test or a new dependency changes the relations with no edit here.

## the comment page

A file points at its comment page where the comment-pages config places one and that page is among the given paths. The config is read once
and passed to Get-CommentPage for each file.

## the module folder

A module points at each module it declares as a dependency. Its folder stands for it, and a group name in the dependencies is no module, so
it gives no edge. An edge is made only when both folders hold at least one of the given paths.
