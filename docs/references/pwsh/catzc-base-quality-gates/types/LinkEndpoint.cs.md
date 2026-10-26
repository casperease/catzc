# pwsh/Base.QualityGates/types/LinkEndpoint.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `public sealed class LinkEndpoint`, written with `//`.

```text
One end of a relation as its facets, derived from the declarations and never read from a head (ADR-REPO-LINKS-ENDPOINTSAREFACETS).
An empty facet is a file without one: no aspect in a track without aspects, no module outside a module.
```
