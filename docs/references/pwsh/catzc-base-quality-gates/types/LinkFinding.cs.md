# pwsh/Base.QualityGates/types/LinkFinding.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System.Globalization;`, written with `//`.

```text
One finding of the link engine: where (repository-relative file, 1-based line and column), which link kind,
what was found, a human message, and the replacement text the aligner writes (empty when it cannot fix it).
```
