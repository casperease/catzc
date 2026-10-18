# automation/Catzc.Base.Docs/Format-MarkdownParagraph.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its
comment sat above (Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Wraps one paragraph or list item of generated markdown at the 140-column prose width, the way Prettier fills it.

### description

Greedy fill — each line takes as many words as fit in Width columns, prefix included — which is what Prettier's
`proseWrap: always` produces, so generated markdown (the ADR index, the glossary, the contract reference) is
formatter-stable ([ADR-REPO-FORMAT#5](../../../adr/repository/uniform-formatting.md#rule-adr-repo-format5)). The first
line carries FirstPrefix (a list marker such as '- '), every later line ContinuationPrefix (the marker's indent).

Prettier never breaks inside an inline code span or a link, so a `code span` and a [text](target) link each count
as part of one unbreakable word, spaces included. A word longer than the width stays whole on its own line.

### parameter Text

The paragraph text; runs of whitespace outside code spans and links collapse to one space.

### parameter FirstPrefix

The prefix of the first line (e.g. '- ' or '  - '). Empty for a plain paragraph.

### parameter ContinuationPrefix

The prefix of every following line (e.g. '  ' or '    '). Empty for a plain paragraph.

### parameter Width

The maximum line width, prefix included. Defaults to 140, the repository's markdown width.

### outputs

`[string[]]` The wrapped lines.

### example 1

```powershell
Format-MarkdownParagraph -Text $definition -FirstPrefix '- ' -ContinuationPrefix '  '
```
