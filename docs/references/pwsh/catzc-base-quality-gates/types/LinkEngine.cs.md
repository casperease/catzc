# pwsh/Catzc.Base.QualityGates/types/LinkEngine.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
The link engine behind Format-Links and Test-Links
([ADR-REPO-LINK-ALIGNEDBYTOOL](/docs/drs/repository/markdown-links.md#rule-adr-repo-link-alignedbytool)): runs over a list of repository files in
parallel and, per file, by kind ([ADR-REPO-LINK-KINDBYFILE](/docs/drs/repository/markdown-links.md#rule-adr-repo-link-kindbyfile)):
  Code      — every comment span (CommentLexer) is rewritten into canonical code links (CodeLinkRewriter); a
              comment line that outgrows its limit is wrapped per the configured LinkWrap; a PowerShell string
              naming a docs/drs path that does not exist is reported (strings are data,
[ADR-REPO-LINK-STRINGSAREDATA](/docs/drs/repository/markdown-links.md#rule-adr-repo-link-stringsaredata)); a rule citation spelled
              `ADR-X:n` in any string literal, outside a `### Rule` heading, becomes `ADR-X#n` and stays plain
              ([ADR-REPO-LINK-ONECITATIONSPELLING](/docs/drs/repository/markdown-links.md#rule-adr-repo-link-onecitationspelling)), except in a file the
              string_citations check exempts (links.yml).
  Markdown  — the file's links are checked and aligned (MarkdownLinkScanner).
It reads files and never writes them: the result carries each changed file's new text. Findings carry real
1-based line and column numbers of the original text.
```

## comment:2

Above `public LinkEngine(string repositoryRoot, DrsCitationMap map, DrsConfig adrs,...`, written with `//`.

```text
adrs: the registry; its code grammar (CodeForm) is what the citation checks match, its root where the record paths live.
lineLimits: extension ('.ps1') -> line limit; an extension not listed takes defaultLineLimit.
selfUrlPrefix: this repository's web URL, or null to skip the self-URL check.
trackedFiles: the paths git tracks, so a markdown link to a file GitHub does not have is reported; null to skip.
stringCitations: the string-citation check's settings (links.yml string_citations); its exempt globs.
```

## comment:3

Above `int end = start + length;`, written with `//`.

```text
A trailing comment may already have been continued on the following lines, indented under its marker
(`$x = 1   # text` then `         # more`): those lines belong to it and are merged back before aligning.
```

## comment:4

Above `if (continuations > 0 && !InsertedLink.IsMatch(rewritten))`, written with `//`.

```text
Continuation lines are merged only to repair a code link wrapped under its marker; any other aligned
comment block is left as written, and the trailing comment is aligned on its own.
```

## comment:5

Above `if (trailing && (continuations > 0 || (rewrote && column + rewritten.Length >...`, written with `//`.

```text
A trailing comment that no longer fits beside its code — or that had been continued under its marker —
moves onto its own line above the statement, at the statement's indentation, and wraps there.
```

## comment:6

Above `string AlignStringCitations(string text, string file, string extension,...`, written with `//`.

```text
Reports every numbered citation in the file's string literals as StringNumbered, unfixable, since it names no
rule; the text is returned as written. A file the string_citations check exempts is not read.
```

## comment:7

Above `string Wrap(string comment, int column, string marker, string newline, int...`, written with `//`.

```text
Wraps the lines of a rewritten comment that carry an inserted code link and outgrow the limit: the line is broken
before the link's word (never inside the link), and the continuation repeats the comment prefix and indent.
A line that still cannot fit is reported Overlong. With LinkWrap.Off every overlong line is reported, none broken.
```

## comment:8

Above `static int BreakPoint(string line, int room, int tailRoom)`, written with `//`.

```text
Where to break an overlong line. Preferred: before the word holding an inserted code link, so the link and the
rest of its sentence move down together (the latest such break whose remainder fits tailRoom). Otherwise the
last space that fits within room, outside any link and inline code span, after the line's first word. 0 when no
break helps.
```

## comment:9

Above `return 0;`, written with `//`.

```text
The first word (a link longer than the room left) crosses the limit by itself: moving the rest down would
only strand a few words on their own line, so the line stays long and is reported Overlong.
```

## comment:10

Above `static string ContinuationPrefix(string body, int index, int column, string...`, written with `//`.

```text
The text a continuation line starts with: a line comment repeats its marker at the comment's column; a block
comment line repeats its own indent (and a leading '* ' in a C-style block).
```
