# pwsh/Base.MarkdownMeta/Format-MarkdownParagraph.ps1

Wraps one paragraph or list item of generated markdown at the prose width, so the generators' output is already what the formatter would
write.

## help

### synopsis

Wraps one paragraph or list item of generated markdown at the 140-column prose width, the way Prettier fills it.

### description

Greedy fill — each line takes as many words as fit in Width columns, prefix included — which is what Prettier's `proseWrap: always`
produces, so generated markdown (the ADR index, the glossary, the contract reference) is formatter-stable
([ADR-REPO-FORMAT-GENERATEDARTIFACTSFORMATTED](../../../drs/repository/uniform-formatting.md#rule-adr-repo-format-generatedartifactsformatted)).
The first line carries FirstPrefix (a list marker such as '- '), every later line ContinuationPrefix (the marker's indent).

Prettier never breaks inside an inline code span or a link, so a `code span` and a `[text](target)` link each count as part of one
unbreakable word, spaces included. A word longer than the width stays whole on its own line.

### parameter `Text`

The paragraph text; runs of whitespace outside code spans and links collapse to one space.

### parameter `FirstPrefix`

The prefix of the first line (e.g. '- ' or ' - '). Empty for a plain paragraph.

### parameter `ContinuationPrefix`

The prefix of every following line (e.g. ' ' or ' '). Empty for a plain paragraph.

### parameter `Width`

The maximum line width, prefix included. Defaults to 140, the repository's markdown width.

### outputs

`[string[]]` The wrapped lines, written as one array object (the closing unary comma), so a caller takes the object whole: assign it, or
join it (``-join "`n"``), and never pipe it expecting one line per item.

### example 1

```powershell
Format-MarkdownParagraph -Text $definition -FirstPrefix '- ' -ContinuationPrefix '  '
```
