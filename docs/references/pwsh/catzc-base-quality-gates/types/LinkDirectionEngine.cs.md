# pwsh/Catzc.Base.QualityGates/types/LinkDirectionEngine.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `public static class LinkDirectionEngine`, written with `//`.

```text
Judges each relation against the rows: the first matching row decides, and a relation no row allows is denied. Pure: the edges, the
endpoints and the config are passed in, and it reads no file and no config (ADR-REPO-LINKS-DIRECTIONSAREROWS).
```
