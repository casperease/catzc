# automation/Catzc.Base.Docs/types/GitHubAnchor.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
GitHub's heading anchors: the slug GitHub renders for a markdown heading, and the full anchor set of a
markdown document — what a link's #fragment must name to resolve on GitHub
([ADR-REPO-LINK#2](/docs/adr/repository/markdown-links.md#rule-adr-repo-link2)).

The slug follows GitHub's rendered-text algorithm: inline markup is reduced to its text (code-span backticks
dropped, a link to its text, emphasis asterisks dropped), the text is lowercased, every character that is not
a letter, digit, space, hyphen, or underscore is removed, and each space becomes a hyphen. Duplicate headings
in one document take -1, -2, … suffixes in document order. Headings inside fenced code blocks are not
headings; an explicit <a id="…"> or <a name="…"> is an anchor too.
```

## comment:2

Above `public static IReadOnlyCollection<string> Anchors(string markdown)`, written with `//`.

```text
Every anchor a markdown document exposes: heading slugs (with GitHub's -1/-2 duplicate suffixes) plus
explicit HTML anchors. Fenced code blocks are skipped.
```
