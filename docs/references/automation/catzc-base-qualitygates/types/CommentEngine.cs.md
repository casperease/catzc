# docs/references/automation/catzc-base-qualitygates/types/CommentEngine.cs.md

`automation/Catzc.Base.QualityGates/types/CommentEngine.cs`

<!-- cspell:ignore EXTERNALHELP FORWARDHELPTARGETNAME FORWARDHELPCATEGORY REMOTEHELPRUNSPACE w1 w2 -->

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `using System;`.

```text
The comment engine behind Export-Comments, Build-CommentView, Format-Comments and Test-Comments: pure functions
over a file's text, so the move and its inverse can be proved on fixtures. A file carries one residue per long
comment — an insight line, then a line with the block's ADR citations and the docs link
`[comment:N](/<page>#commentN)` — and the prose lives verbatim in the file's comment page, so each has exactly one
living copy ([ADR-PRIN-ONELIVE#1](/docs/adr/principles/one-living-version.md#rule-adr-prin-onelive1)). What
moves is decided by CommentsConfig (comments.yml,
[ADR-PRIN-CONFIG#1](/docs/adr/principles/configure-not-program.md#rule-adr-prin-config1)); where a comment is
at all is CommentLexer's answer, the one place that knows each language family's comment syntax.
  FindBlocks   the blocks that would move: own-line comment runs, delimited blocks, and comment-based help
               sections with at least min_lines prose lines, not kept by a configured head, not a residue already
  Export       the file's new text and its page's new text; numbers continue from the page's highest section and
               are never reused, and an existing section is kept as written (a person may have edited it)
  FindResidues the residues a file carries, for the view and the checks
  View         the inverse: every residue replaced by its section's lines, re-prefixed with the residue's indent
               and marker — the annotated copy Build-CommentView writes under out/
A page holds each comment in a fenced `text` block, because the Markdown formatter reflows prose (proseWrap) and
would rewrite what was moved; the fence keeps the transfer one-to-one and formatter-stable
([ADR-REPO-FORMAT#5](/docs/adr/repository/uniform-formatting.md#rule-adr-repo-format5)).
```

## comment:2

Above `static IEnumerable<CommentBlock> HelpSections(Lines lines, int startLine, int...`.

```text
One block per `.KEYWORD` section body: the lines after the keyword line up to the next keyword line or the
closing `#>` line, trailing blank lines left in place. A `#>` that shares a body line leaves the block alone.
```

## comment:3

Above `public static CommentFileResult Export(string text, string extension, string...`.

```text
text: the file; pagePath: its page, repository-relative; existingPageText: the page as it is, or null.
lineLimit: the file's line limit, which the provisional insight line is cut to fit.
```

## comment:4

Above `public static string Insight(string text, int maxLength)`.

```text
The provisional insight: the block's first sentence without its links and citations (those go on the link
line), cut at a word to fit; the sonnet pass rewrites it.
```

## comment:5

Above `public static IReadOnlyList<string> IgnoredWords(string text, string extension)`.

```text
The words a file's spell-checker directives ignore (`cspell:ignore w1 w2 -- why`), each once, in order: the page that
receives the file's prose ignores them too, or moved prose fails the spell check the file passed.
```

## comment:6

Above `static string WithIgnoreLine(string prefix, string repoRelativePath,...`.

```text
The page head with one `<!-- cspell:ignore … -->` line holding its own words plus the file's, below the source
path; unchanged when the file ignores nothing new.
```
