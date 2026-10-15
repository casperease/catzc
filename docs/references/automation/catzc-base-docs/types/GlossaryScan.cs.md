---
catzc:
  derived:
    path: docs/references/automation/catzc-base-docs/types/GlossaryScan.cs.md
    kind: comment-page
    body_sha: "24ea4129199e"
    adrs: []
    links: []
---

# automation/Catzc.Base.Docs/types/GlossaryScan.cs

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `using System;`.

```text
The two glossary checks that read every in-scope file's prose (GlossaryProse):
  Phrasing (G4)  an avoided phrasing of a concept, as a whole word sequence, in a surface its source checks;
  Forms    (G6)  a qualified use of a concept's head word whose qualifier the concept does not list as a form (a
                 function word, a number, or an allowed form is fine), and — unless the concept takes verb forms — its
                 -ed / -ing verb forms.
Each source is checked over the tracked files its options' scope selects and its exclude does not, in the surfaces its
options list. A file's prose is read once per run into the caller's surface cache, however many sources and checks
scan it. The result is one message per hit, sorted by file, line and message, duplicates removed — the order and
text the checks have always reported.
```

## comment:2

Above `static readonly HashSet<string> FunctionWords = new HashSet<string>(new[]`.

```text
Words that only point at, count, own, or join a noun — never a qualifier that names a kind of it: articles,
determiners, quantifiers, possessives (the 's' of "the template's slot"), prepositions, conjunctions, and adverbs
that only limit the noun ("only slots").
```

## comment:3

Above `Qualified = new Regex("(?<![A-Za-z0-9.])(?<q>[A-Za-z0-9]+)(?:[ \\t]+|[...`.

```text
The qualifier is the last word before the head ('commit' in 'pre-commit gate'), joined by spaces,
one line break, or a hyphen. A word after a dot is a keyword, not a qualifier (`.PARAMETER Slot`).
```

## comment:4

Above `static IEnumerable<(string, GlossarySegment)> Segments(Source source,...`.

```text
Every segment, in a surface the source checks, of every tracked Markdown or PowerShell file the source's scope
selects and its exclude does not; a file's prose is read into the surface cache on first use.
```
