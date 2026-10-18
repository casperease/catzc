# pwsh/Catzc.Base.MarkdownMeta/Remove-MarkdownFrontMatter.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

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
