# pwsh/Catzc.Base.Drs/types/DrsCitationForm.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
The one citation spelling has two forms, chosen by the line's width
([ADR-REPO-LINK-ONECITATIONSPELLING](/docs/drs/repository/markdown-links.md#rule-adr-repo-link-onecitationspelling)): an inline citation
whose line outgrows the markdown width becomes a reference, its definition at the end of the file.
```

## comment:2

Above `public static string ToReference(string text, string path, ISet<int> lines,...`, written with `//`.

```text
Respells, on each listed line wider than width, its inline citations as references, the longest destination first, until the line fits.
The label is plumbing, r1, r2, ... in order of first use: a destination already defined keeps its label, and a new one takes the next
free number, so an existing label never moves and a definition stays as short as its destination allows.
```
