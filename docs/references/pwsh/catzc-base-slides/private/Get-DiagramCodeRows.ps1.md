# pwsh/Base.Slides/private/Get-DiagramCodeRows.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

The query rows of a C4 slide: the files of one folder as cells, and the links between them as edges.

### description

The point's git-tracked files are the cells, never its build output, and its tests are left out so they never crowd the slide. Each file's
kind comes from the place its language gives it: `private` for a private function, `type` for a type, `code` for a `.ps1` at the folder's
top, else `file`. One walk of the link graph into the point answers every relation; an edge between two of its files is kept once, and a
file's link to itself is no edge. A point that is not a folder of the repository throws.

### parameter `Point`

The folder the slide stands at, repository-relative.

### parameter `RepositoryRoot`

The repository the point lies in.

### outputs

`[System.Collections.Specialized.OrderedDictionary]` The rows: `point`, `level` (`C4`), `nodes` (each `id`, `label`, `kind`) and `edges`
(each `from`, `to`).

### example 1

```powershell
Get-DiagramCodeRows -Point pwsh/Base.Slides -RepositoryRoot (Get-RepositoryRoot)
```

## comment:1

Above `$languages = Get-Config -Config languages`, written with `#`.

```text
C4: one module's tracked files, its tests left out, each a glyph of the kind its folder's role draws, and the link edges between two
of them; a build's output beside the sources is no file of the module.
```

## comment:2

Above `$nodes.Add([ordered]@{ id = $id; label =...`, written with `#`.

```text
The glyph's kind already says what the file is, so its label is the name without the extension, short enough
for its box.
```
