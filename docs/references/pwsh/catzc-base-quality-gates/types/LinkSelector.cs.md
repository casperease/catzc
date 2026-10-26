# pwsh/Base.QualityGates/types/LinkSelector.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `public sealed class LinkSelector`, written with `//`.

```text
One side of a direction row: lists of facet values, an empty list meaning any; never a glob (ADR-REPO-LINKS-DIRECTIONSAREROWS).
A class is a role, which selects its subkinds too, or role/subkind, with at most one '*' standing for any run of characters.
```
