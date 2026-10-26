# pwsh/Catzc.Base.Globs/Get-RepositoryFilter.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Resolves the repository's filters, the lamps of the working view, to the include and exclude sets each claims files by.

### description

Each filter of filters.yml is resolved to its sets, in declaration order: what a lamp claims, as the editor's lamps and every other engine
read it, so a file is classified by the patterns the model holds and never by a list of files
([DDR-FILTER-DECLAREDONCE](../../../drs/design/repository-filters.md#rule-ddr-filter-declaredonce)).

### parameter `Name`

The filters to resolve, by name. Default: every declared filter, in declaration order.

### outputs

`[pscustomobject]` one per filter: its name and its sets.

## comment:1

Above `$literal = { param([string[]] $Paths) foreach ($path in $Paths) {`, written with `#`.

```text
A set claims a path that one of its includes matches and none of its excludes does. A literal path claims itself and what lies
under it, so a new file is classified by the same patterns the model holds, never by a stale list of files.
```

## comment:2

Above `$owned = {`, written with `#`.

```text
A track's files: each of its places and what lies under it, less the places of the tracks nested inside it (`.github` without
`.github/workflows`), because every file is in exactly one track.
```

## comment:3

Above `if (@($filter.extensions).Count -gt 0) {`, written with `#`.

```text
A filter with extensions is that part of its sets: a tree include ('<folder>/**', '**') keeps only those extensions below it, a
file include ('<folder>/*.ps1', a literal path) stays when its extension is one of them, and the excludes stay as they are.
```

## comment:4

Above `$kinds ??= (Get-Config -Config file-kinds).kinds`, written with `#`.

```text
A file kind's globs as file-kinds.yml declares them, its subkinds' included
([ADR-REPO-FILEMETA-METAKIND](/docs/drs/repository/file-meta.md#rule-adr-repo-filemeta-metakind)).
```
