# pwsh/Base.QualityGates/types/CommentEngine.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `public static string FreshPage(string repoRelativePath, int width) =>`, written with `//`.

```text
The opening of a page the exporter or the help move writes for the first time: its title and the line that says what it holds,
wrapped at the markdown width, so a new page is born formatted.
```
