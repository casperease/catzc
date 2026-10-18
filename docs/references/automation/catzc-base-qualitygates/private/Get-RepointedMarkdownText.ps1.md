# automation/Catzc.Base.QualityGates/private/Get-RepointedMarkdownText.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Re-points a Markdown file's #fragment links at headings whose anchor changed, and returns the text.

### description

Every inline link `[text](<target>#<fragment>)` — a relative target, or none for the file's own headings — is resolved against the file's
folder; when `<resolved path>#<fragment>` is a key of Rename, the fragment is replaced by its value. The link text, the target as written,
and every other byte are kept, so the text is returned unchanged when no link matches. Used by the heading normal form, which renames
anchors ([ADR-REPO-FORMAT#7](../../../../adr/repository/uniform-formatting.md#rule-adr-repo-format7)).

### parameter `RelativePath`

The file's repository-relative, '/'-separated path.

### parameter `Text`

The file's content.

### parameter `Rename`

'`<repository-relative path>#<old anchor>`' -> new anchor.

### outputs

`[string]` the text with matching fragments re-pointed.
