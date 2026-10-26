# pwsh/Base.MarkdownMeta/types/MarkdownMetaBlock.cs

Renders and reads the `catzc:` meta block of a Markdown front matter, in its one canonical form.

## Parts

The block has three parts, each a two-space-indented key under `catzc:`: `immutable`, the edges and `config`
([ADR-REPO-FILEMETA-HEADPOLICY](../../../../drs/repository/file-meta.md#rule-adr-repo-filemeta-headpolicy)). The facts come as an ordered
dictionary, so their order is the order written.

## Render

The first overload renders the place facts and then the edges in the order given, then the authored config lines as written. A value is a
scalar or a list of scalars. No facts and no config lines render no block at all.

The second overload takes a header note as well. It renders the imprinted facts at the first level (the docs edge first), the header note,
the place facts of a generated head, then the authored config.

## Reading

`ConfigLines`, `WithoutConfig`, `SectionKeys`, `ImmutableKeys`, `EdgeKeys` and `EdgeList` read a rendered block back, so a caller changes
one part and keeps the rest.
