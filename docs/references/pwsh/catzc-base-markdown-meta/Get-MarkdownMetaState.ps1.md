# pwsh/Base.MarkdownMeta/Get-MarkdownMetaState.ps1

Reads a Markdown text's front matter and its meta block into one state object, so a caller can decide what to imprint without touching the
text.

## help

### synopsis

Reads what a Markdown text says about its own meta block, without changing it.

### description

Pure: it takes the text, reads no file and no config. The body is what follows the front matter, and its hash drops the blank line that
separates written front matter from it, so imprinting never changes the hash it records
([ADR-REPO-FILEMETA-IMPRINTEDPARTS](../../../drs/repository/file-meta.md#rule-adr-repo-filemeta-imprintedparts)).

It rests on [ADR-REPO-FILEMETA-HEADPOLICY](../../../drs/repository/file-meta.md#rule-adr-repo-filemeta-headpolicy).

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
