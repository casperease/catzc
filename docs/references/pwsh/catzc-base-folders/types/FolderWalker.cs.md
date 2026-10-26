# pwsh/Base.Folders/types/FolderWalker.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its
comment sat above (Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `public static string[][] WalkRelative(string root, int depth,...`, written with `//`.

```text
One pass that lists the files and the folders apart, each relative to relativeTo with '/' separators: the walk a caller
that needs both would otherwise make twice, then cut path by path.
```
