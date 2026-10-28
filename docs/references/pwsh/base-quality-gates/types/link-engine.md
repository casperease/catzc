# pwsh/Base.QualityGates/types/LinkEngine.cs

The link engine behind `Format-Links` and `Test-Links`
([ADR-REPO-LINK-ALIGNEDBYTOOL](../../../../drs/repository/markdown-links.md#rule-adr-repo-link-alignedbytool)). It runs over a list of
repository files in parallel and treats each by kind
([ADR-REPO-LINK-KINDBYFILE](../../../../drs/repository/markdown-links.md#rule-adr-repo-link-kindbyfile)). It reads files and never writes
them: the result carries each changed file's new text. Findings carry real 1-based line and column numbers of the original text.

## Kinds

- **Code** — every comment span (`CommentLexer`) is rewritten into canonical code links (`CodeLinkRewriter`). A comment line that outgrows
  its limit is wrapped per the configured `LinkWrap`. A PowerShell string naming a docs/drs path that does not exist is reported, since
  strings are data ([ADR-REPO-LINK-STRINGSAREDATA](../../../../drs/repository/markdown-links.md#rule-adr-repo-link-stringsaredata)). A rule
  citation spelled `ADR-X:n` in a string literal, outside a `### Rule` heading, is reported as numbered and unfixable, since it names no
  rule ([ADR-REPO-LINK-ONECITATIONSPELLING](../../../../drs/repository/markdown-links.md#rule-adr-repo-link-onecitationspelling)); the text
  is returned as written. A file the `string_citations` check exempts in `links.yml` is not read.
- **Markdown** — the file's links are checked and aligned (`MarkdownLinkScanner`).

## Construction

The constructor takes:

- `drs`: the DRS config; its code grammar (`CodeForm`) is what the citation checks match, and its root is where the record paths live.
- `lineLimits`: extension (`.ps1`) to line limit; an extension not listed takes `defaultLineLimit`.
- `selfUrlPrefix`: this repository's web URL, or null to skip the self-URL check.
- `trackedFiles`: the paths git tracks, so a markdown link to a file GitHub does not have is reported; null to skip.
- `stringCitations`: the string-citation check's settings (`links.yml` `string_citations`), with its exempt globs.

`Run` also takes `collectEdges`, which asks the walk for the relations it recognises as well
([ADR-REPO-LINKS-CHECKEDBYONEGATE](../../../../drs/repository/links-in-repository.md#rule-adr-repo-links-checkedbyonegate)).

## Trailing comments

A trailing comment may already have been continued on the following lines, each a `# more` indented to sit under its marker. Those lines
belong to it and are merged back before aligning, but only to repair a code link wrapped under its marker. Any other aligned comment block
is left as written, and the trailing comment is aligned on its own.

A trailing comment that no longer fits beside its code, or that had been continued under its marker, moves onto its own line above the
statement, at the statement's indentation, and wraps there.

## Wrapping

`Wrap` wraps the lines of a rewritten comment that carry an inserted code link and outgrow the limit. The line is broken before the link's
word, never inside the link, and the continuation repeats the comment prefix and indent. A line that still cannot fit is reported
`Overlong`. With `LinkWrap.Off` every overlong line is reported and none is broken.

`BreakPoint` chooses where. It prefers the break before the word holding an inserted code link, so the link and the rest of its sentence
move down together: the latest such break whose remainder fits the room left for the tail. Otherwise it takes the last space that fits,
outside any link and inline code span, after the line's first word. It returns 0 when no break helps. The first word, such as a link longer
than the room left, crosses the limit by itself: moving the rest down would only strand a few words on their own line, so the line stays
long and is reported.

`ContinuationPrefix` gives the text a continuation line starts with. A line comment repeats its marker at the comment's column. A block
comment line repeats its own indent, and in a C-style block also the leading `*` and the space after it.
