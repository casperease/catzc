# pwsh/Base.MarkdownMeta/Remove-MarkdownFrontMatter.ps1

Cuts the YAML front matter off a Markdown text and returns the rest, for copies that carry the content but not the file's meta.

## help

### synopsis

Returns a Markdown text without its YAML front matter.

### description

For a copy that carries the content but not the file's meta: a generated README, which a reader opens with its title first. The blank line
that separates written front matter from the body goes with it. A text with no front matter comes back unchanged. Pure: it reads no file and
no config.

### parameter `Text`

The whole Markdown file as text.

### outputs

`[string]` the text from its first body line on.

### example 1

```powershell
Remove-MarkdownFrontMatter -Text $text
```
