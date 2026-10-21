# pwsh/Catzc.Base.MarkdownMeta/types/MarkdownMetaBlock.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `public const string ImmutableKey = "immutable";`, written with `//`.

```text
The three parts of the block, each a two-space-indented key under `catzc:`
([ADR-REPO-FILEMETA-HEADPOLICY](/docs/drs/repository/file-meta.md#rule-adr-repo-filemeta-headpolicy)). The facts come as an
ordered dictionary, so their order is the order written.
```

## comment:2

Above `public static IReadOnlyList<string> Render(IDictionary immutable, IDictionary...`, written with `//`.

```text
Renders the block in its one canonical form: the place facts and then the edges in the order given, then the authored config lines as
written.
A value is a scalar or a list of scalars. No facts and no config lines render no block at all.
```
