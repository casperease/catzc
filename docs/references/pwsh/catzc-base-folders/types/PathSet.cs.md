# pwsh/Catzc.Base.Folders/types/PathSet.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `public sealed class PathSet`, written with `//`.

```text
A set of file paths a type owns: files named under a base, and the files a pattern finds through the bounded walker; full paths, sorted
and unique, so the same tree always gives the same set.
```

## comment:4

Above `public PathSet AddPattern(string folder, string pattern, int depth)`, written with `//`.

```text
The files below a folder whose names match a pattern, to the depth given (1, the folder itself), the config's folder names pruned; a
folder that does not exist adds nothing.
```
