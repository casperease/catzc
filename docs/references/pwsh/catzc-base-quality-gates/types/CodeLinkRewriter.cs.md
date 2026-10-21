# pwsh/Catzc.Base.QualityGates/types/CodeLinkRewriter.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
Rewrites the ADR references in one comment into canonical code links
([ADR-REPO-LINK-CODELINKS](/docs/adr/repository/markdown-links.md#rule-adr-repo-link-codelinks)):
  `[ADR-<CODE>](/docs/adr/<path>.md)`                                 a whole ADR
  `[ADR-<CODE>-<NAME>](/docs/adr/<path>.md#rule-adr-<code>-<name>)`  one rule
Every other spelling is recognised — a bare, ./, ../ or rooted docs/adr path, an ADR file name alone, a bare
citation, a path followed by its own citation, and a markdown link in another shape — and a numbered citation is
reported, since it names no rule. The citation code is the source of truth: the destination is derived from it (AdrCitationMap), so a stale
path is re-pointed and a text/destination mismatch resolves in favour of the code.
Inline code spans and a PowerShell help block's .EXAMPLE sections are literal and never touched. Pure: it returns
the new comment text and reports what it found at comment-relative offsets; the engine owns files and positions.
```

## comment:2

Above `@"|(?<path>(?<![^\s(\[{,;:'""*])(?:\.{1,2}/)*/?docs/adr/[A-Za-z0-9_\-./]+?\.m...`, written with `//`.

```text
A path or file name starts a word: it follows the comment start, a space, or opening punctuation, never
another character — `<root>/docs/adr/index.md` is a placeholder path, not a reference.
```

## comment:3

Above `@"|(?<cite>(?<!\w)(?<!(?:^|\D)-)(?<code>ADR(?:-[A-Z][A-Z0-9]*)+)(?![\w*]|-[A-...`, written with `//`.

```text
A citation is not glued to a word; a '-' before it is allowed only after a digit, as a range or date dash is.
```

## comment:4

Above `public string Rewrite(string comment, bool tolerateUnknownCodes, List<Hit>...`, written with `//`.

```text
Rewrites one comment. tolerateUnknownCodes (test files) skips citations of unregistered codes — test comments
name fixture ADRs on purpose. Returns the new comment text; hits and the inserted link texts are appended.
```

## comment:5

Above `int Adjacent(string comment, int at, bool[] literal, out string code)`, written with `//`.

```text
The citation right after a path — `x.md (ADR-X-NAME)`, `x.md, Rule ADR-X-NAME`, `x.md — ADR-<CODE>` — merges into the
path's link. Returns how many characters it covers (0 when there is none); a ')' is taken only when the
separator opened it.
```

## comment:6

Above `int RepeatedLink(string comment, int at, bool[] literal, string canonical)`, written with `//`.

```text
A bracketed link right after a bare citation that names the same ADR or rule — `ADR-X-NAME ([x](/docs/adr/x.md#rule-adr-x-name))`,
the link perhaps on the next line — is the same reference spelled twice. It merges into the citation's one
canonical link instead of becoming a second copy of it. Returns how many characters it covers (0 when there is
none, or when the link points elsewhere).
```
