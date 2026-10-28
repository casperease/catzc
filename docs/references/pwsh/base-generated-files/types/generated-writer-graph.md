# pwsh/Base.GeneratedFiles/types/GeneratedWriterGraph.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading. Prose written above the first section survives every
later export.

## comment:1

Above `public static IReadOnlyList<Catzc.Base.Variants.GeneratedWriterRow>...`, written with `//`.

```text
The module writer rows in render order (ADR-REPO-ROOTCFG-DERIVEDRENDERORDER): a writer comes after every writer one of whose output
globs overlaps one of its input globs, ties by name. A writer reading its own output is no edge; a cycle between writers throws.
```

## comment:2

Above `private static string CycleMessage(Dictionary<string, int> waiting,...`, written with `//`.

```text
Every writer left unsorted waits on another left unsorted, so walking back from the first by name meets a writer twice: that loop is
the cycle, named from its first writer by name in render direction.
```
