# pwsh/Catzc.Base.Config/types/ConfigDefaultDifference.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `public static IReadOnlyList<ConfigDefaultDifference> Compare(Type configType,...`, written with `//`.

```text
The keys of a shipped file whose scalar value differs from the type's Default<Key> constant (the key in Pascal case); a key with no such
constant, or one whose default is no scalar (a list or a map), compares nothing.
```
