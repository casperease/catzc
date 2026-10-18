# automation/Catzc.Base.MarkdownMeta/Format-MarkdownMetaBlock.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Returns a Markdown text with its meta block imprinted from the given facts.

### description

The `immutable` and `edges` parts are written from -Immutable and -Edges in the order given, one canonical form, so the same facts always
give the same bytes. The authored `config` part and every other byte of the text are kept as written. With no facts, no edges and no config
lines the block is removed. Pure: it reads no file and no config, and it returns the text rather than writing it.

It rests on [ADR-REPO-FILEMETA#3](../../../adr/repository/file-meta.md#rule-adr-repo-filemeta3).

### parameter `Text`

The whole Markdown file as text.

### parameter `Immutable`

The place facts, an ordered dictionary of key to value; a value is a scalar.

### parameter `Edges`

The outgoing edges, an ordered dictionary of edge name to value; a value is a scalar or a list of scalars.

### parameter `Key`

The front-matter key path of the block: catzc at the top level (the default), or a dotted path such as metadata.catzc where the carrier
nests it under another tool's keys; a parent key the text lacks is written, a parent that holds a flow or scalar value is an error.

### outputs

`[string]` the whole text, with the meta block replaced.

### example 1

```powershell
Format-MarkdownMetaBlock -Text $text -Immutable ([ordered]@{ with_body_sha = '3fa91c0d2b7e'; kind = 'adr' }) -Edges ([ordered]@{ cites = @('ADR-WIDGET#1') })
```
