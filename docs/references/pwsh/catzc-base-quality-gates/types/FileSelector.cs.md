# pwsh/Base.QualityGates/types/FileSelector.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `public static bool ClassMatches(string pattern, string fileClass)`, written with `//`.

```text
A class name, or a name with one '*' standing for any run of characters. A file's class is its kind, or kind/subkind; a pattern
without a '/' names the kind, so it selects the kind whatever its subkind, and a pattern with one names a subkind.
```
