# pwsh/Base.CodeMeta/types/CommentPagesConfig.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading. Prose written above the first section survives every
later export.

## comment:1

Above `public IReadOnlyDictionary<string, IReadOnlyList<string>>...`, written with `//`.

```text
Page to source, the projection's other way: the normal form cannot be read back, so the files map forward once and the result is
inverted. Each page lists every source that renders to it (a module folder for its article); two or more is a collision.
```
