# docs/references/automation/catzc-base-markdownmeta/types/MarkdownMetaBlock.cs.md

`automation/Catzc.Base.MarkdownMeta/types/MarkdownMetaBlock.cs`

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `public const string DerivedKey = "derived";`.

```text
The two parts of the block, each a two-space-indented key under `catzc:`
([ADR-REPO-FILEMETA#1](/docs/adr/repository/file-meta.md#rule-adr-repo-filemeta1)). The facts come as an
ordered dictionary, so their order is the order written.
```

## comment:2

Above `public static IReadOnlyList<string> Render(IDictionary derived,...`.

```text
Renders the block in its one canonical form: the derived facts in the order given, then the authored config lines as written.
A value is a scalar or a list of scalars. No facts and no config lines render no block at all.
```
