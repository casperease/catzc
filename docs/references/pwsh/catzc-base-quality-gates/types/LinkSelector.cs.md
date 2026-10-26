# pwsh/Base.QualityGates/types/LinkSelector.cs

One side of a direction row (ADR-REPO-LINKS-DIRECTIONSAREROWS): lists of facet values, where an empty list means any. It never holds a glob.

A class is a role, which selects its subkinds too, or `role/subkind`, with at most one `*` standing for any run of characters.
