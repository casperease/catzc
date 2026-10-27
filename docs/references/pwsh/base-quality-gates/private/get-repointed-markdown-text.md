# pwsh/Base.QualityGates/private/Get-RepointedMarkdownText.ps1

Re-points a Markdown file's `#fragment` links at headings whose anchor changed, and returns the new text. Each inline link is resolved
against the heading anchors of the file it names, so a renamed heading does not leave a dead link.

## help

### synopsis

Re-points a Markdown file's #fragment links at headings whose anchor changed, and returns the text.

### description

Every inline link `[text](../../catzc-base-quality-gates/private/<target>#<fragment>)` — a relative target, or none for the file's own
headings — is resolved against the file's folder; when `<resolved path>#<fragment>` is a key of Rename, the fragment is replaced by its
value. The link text, the target as written, and every other byte are kept, so the text is returned unchanged when no link matches. Used by
the heading normal form, which renames anchors
([ADR-REPO-FORMAT-PLAINHEADINGS](../../../../drs/repository/uniform-formatting.md#rule-adr-repo-format-plainheadings)).

### parameter `RelativePath`

The file's repository-relative, '/'-separated path.

### parameter `Text`

The file's content.

### parameter `Rename`

'`<repository-relative path>#<old anchor>`' -> new anchor.

### outputs

`[string]` the text with matching fragments re-pointed.
