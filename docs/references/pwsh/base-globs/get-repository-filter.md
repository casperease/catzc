# pwsh/Base.Globs/Get-RepositoryFilter.ps1

The resolver of the repository's filters, the lamps of the working view, into the include and exclude sets each one claims files by. The
sections after the help say how a set claims.

## help

### synopsis

Resolves the repository's filters, the lamps of the working view, to the include and exclude sets each claims files by.

### description

Each filter of filters.yml is resolved to its sets, in declaration order: what a lamp claims, as the editor's lamps and every other engine
read it, so a file is classified by the patterns the model holds and never by a list of files
([DDR-FILTER-FILTERDECLAREDONCE](../../../drs/design/repository-filters.md#rule-ddr-filter-filterdeclaredonce)).

### parameter `Name`

The filters to resolve, by name. Default: every declared filter, in declaration order.

### outputs

`[pscustomobject]` one per filter: its name and its sets.

## Claiming

A set claims a path that one of its includes matches and none of its excludes does. A literal path claims itself and what lies under it, so
a new file is classified by the same patterns the model holds, never by a stale list of files.

## Tracks

A track's files are each of its places and what lies under it, less the places of the tracks nested inside it (`.github` without
`.github/workflows`), because every file is in exactly one track.

## Extensions

A filter with extensions is that part of its sets. A tree include (`<folder>/**`, `**`) keeps only those extensions below it, a file include
(`<folder>/*.ps1`, a literal path) stays when its extension is one of them, and the excludes stay as they are.

## File kinds

A file kind's globs are those `file-kinds.yml` declares, its subkinds' included
([ADR-REPO-FILEMETA-METAKIND](../../../drs/repository/file-meta.md#rule-adr-repo-filemeta-metakind)).
