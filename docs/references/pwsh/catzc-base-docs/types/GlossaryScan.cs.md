# pwsh/Base.Docs/types/GlossaryScan.cs

The two glossary checks that read every in-scope file's prose ([GlossaryProse](GlossaryProse.cs.md)):

- **Phrasing (G4)** — an avoided phrasing of a concept, as a whole word sequence, in a surface its source checks.
- **Forms (G6)** — a qualified use of a concept's head word whose qualifier the concept does not list as a form, and, unless the concept
  takes verb forms, its -ed and -ing verb forms.

Each source is checked over the tracked files its options' scope selects and its exclude does not, in the surfaces its options list. A
file's prose is read once per run into the caller's surface cache, however many sources and checks scan it. The result is one message per
hit, sorted by file, line and message, duplicates removed.

## Segments

`Segments` yields every segment, in a surface the source checks, of every tracked Markdown or PowerShell file the source's scope selects and
its exclude does not; a file's prose is read into the surface cache on first use.

## What is a qualifier

The qualifier is the last word before the head ('commit' in 'pre-commit gate'), joined by spaces, one line break or a hyphen. A word after a
dot is a keyword, not a qualifier (`.PARAMETER Slot`).

A function word, a number or an allowed form is fine. Function words are the words that only point at, count, own or join a noun, never a
qualifier that names a kind of it: articles, determiners, quantifiers, possessives (the 's' of "the template's slot"), prepositions,
conjunctions, and adverbs that only limit the noun ("only slots").
