# pwsh/Catzc.Base.MarkdownMeta/Get-MarkdownMetaState.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Reads what a Markdown text says about its own meta block, without changing it.

### description

Pure: it takes the text, reads no file and no config. The body is what follows the front matter, and its hash drops the blank line that
separates written front matter from it, so imprinting never changes the hash it records
([ADR-REPO-FILEMETA-IMPRINTEDPARTS](../../../adr/repository/file-meta.md#rule-adr-repo-filemeta-imprintedparts)).

It rests on [ADR-REPO-FILEMETA-HEADPOLICY](../../../adr/repository/file-meta.md#rule-adr-repo-filemeta-headpolicy).

### parameter `Text`

The whole Markdown file as text.

### parameter `Key`

The front-matter key path of the block: catzc at the top level (the default), or a dotted path such as metadata.catzc where the carrier
nests it under another tool's keys.

### outputs

`[pscustomobject]` @{ HasFrontMatter; HasMetaBlock; CanHoldMetaBlock; Body; BodyHash; Sections; ImmutableKeys; EdgeKeys; ConfigLines } —
CanHoldMetaBlock is false when a key above the block holds a flow or scalar value, Sections are the keys directly under `catzc`,
ImmutableKeys the keys under `immutable`, EdgeKeys the edge names under `edges`, and ConfigLines the authored lines under `config`, as
written.

### example 1

```powershell
(Get-MarkdownMetaState -Text $text).BodyHash
```
