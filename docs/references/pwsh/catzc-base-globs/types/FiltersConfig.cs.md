# pwsh/Base.Globs/types/FiltersConfig.cs

The typed record for `filters.yml`: the repository's filters, named views over the hard model (tracks, aspects, generated targets), in
declaration order.

## FiltersConfig

A filter is a union of what its selectors select, and two filters may claim the same file. A filter never redefines a track or an aspect.

## RepositoryFilter

One filter: its name (a lamp's id, in lower snake case), its title (what it shows, for a reader; empty when not given) and its selectors,
each one of the closed selector kinds.
