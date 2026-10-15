# docs/references/automation/catzc-base-qualitygates/Format-Comments.ps1.md

`automation/Catzc.Base.QualityGates/Format-Comments.ps1`

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
A file keeps one residue per long comment — an insight line, then a line with the comment's ADR citations and the
docs link `[comment:N](/<page>#commentN)` — and the prose lives once, in the file's comment page
([ADR-REPO-COMMENTS#1](/docs/adr/repository/comments-in-docs.md#rule-adr-repo-comments1),
[ADR-PRIN-ONELIVE#1](/docs/adr/principles/one-living-version.md#rule-adr-prin-onelive1)). This is the shape
check of the residue ([ADR-REPO-COMMENTS#5](/docs/adr/repository/comments-in-docs.md#rule-adr-repo-comments5)):
one insight line within the file's line limit (.editorconfig max_line_length, with links.yml overrides), with no
link or citation in it, that does not start with one of comments.yml's obvious phrases
([ADR-PRIN-CONFIG#1](/docs/adr/principles/configure-not-program.md#rule-adr-prin-config1)).

What is mechanical is fixed: a residue without an insight line gets the first sentence of its own section as a
provisional one, a link in the insight goes and a citation moves to the docs-link line, and an overlong insight
is cut at a word to its first sentence. What needs a person is left as written and listed as unfixable: an
obvious insight, words on the docs-link line, a residue whose page holds no section, and a comment that still
outgrows a line (run Export-Comments). Test-Comments reports them. Aligning the link itself stays Format-Links'.
The formatter is compiled C# (Catzc.Base.QualityGates.CommentFormatter) over the comment engine's public surface;
files are written as UTF-8 without a BOM, each line keeping its own ending. A source-tree tool: it throws in
build mode (Assert-SourceTree).
```

## comment:2

Section `.PARAMETER PassThru` of the comment-based help.

```text
Return a result object ({ ChangedCount, ChangedFiles, Fixed, Unfixable, DryRun, ElapsedMs }) instead of only the
changed paths.
```
