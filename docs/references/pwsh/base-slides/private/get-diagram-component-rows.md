# pwsh/Base.Slides/private/Get-DiagramComponentRows.ps1

The query behind a C3 slide: it answers with the components a point holds as cells and the edges a query finds between them.

## help

### synopsis

The query rows of a C3 slide: the components a point holds as cells, and how they relate as edges.

### description

What the cells are depends on what the point is:

- the decision-record root: its domains as sets, each `cites` edge one domain citing another;
- one module's folder: that module and every module it calls or is called by, each `calls` edge one dependency;
- a container of modules: the modules under it, with the `calls` edges between them;
- any other folder: the internal modules (`*.psm1`) at its top, with no edges.

A point that is none of these and no folder of the repository throws. An edge from a component to itself is never drawn.

### parameter `Point`

The folder the slide stands at, repository-relative.

### parameter `RepositoryRoot`

The repository the point lies in.

### outputs

`[System.Collections.Specialized.OrderedDictionary]` The rows: `point`, `level` (`C3`), `nodes` (each `id`, `label`, `kind`) and `edges`
(each `from`, `to`, `label`).

### example 1

```powershell
Get-DiagramComponentRows -Point pwsh/Base.Slides -RepositoryRoot (Get-RepositoryRoot)
```
