# pwsh/Catzc.Base.Globs/types/FiltersConfig.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `public sealed class FiltersConfig`, written with `//`.

```text
The repository's filters: named views over the hard model (tracks, aspects, generated targets), in declaration order. A filter is a
union of what its selectors select, and two filters may claim the same file; a filter never redefines a track or an aspect.
```

## comment:2

Above `public sealed class RepositoryFilter`, written with `//`.

```text
One filter: its name (a lamp's id, lower snake case), its title (what it shows, for a reader; empty when not given) and its selectors,
each one of the closed selector kinds.
```
