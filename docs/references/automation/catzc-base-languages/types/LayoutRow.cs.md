# automation/Catzc.Base.Languages/types/LayoutRow.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `public static IReadOnlyList<LayoutRow> Shared { get; } = new[]`, written with `//`.

```text
The rows no single file language owns, so every module has them: assets ship with the module, tests never do.
A language's own rows (public functions at the root, `private/`, `types/`, `configs/`) are declared under it in languages.yml.
```
