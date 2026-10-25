# pwsh/Catzc.Base.QualityGates/types/LinkDirectionFinding.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `public sealed class LinkDirectionFinding`, written with `//`.

```text
A relation that points a way the rows do not allow: the first matching row denies it (Row from 1), no row allows it (Row 0), or an
end has no endpoint, which is reported, never skipped.
```
