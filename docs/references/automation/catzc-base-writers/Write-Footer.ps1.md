---
catzc:
  derived:
    path: docs/references/automation/catzc-base-writers/Write-Footer.ps1.md
    kind: comment-page
    body_sha: "31f8e3d9672e"
    adrs: []
    links: []
---

# automation/Catzc.Base.Writers/Write-Footer.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Pairs with Write-Header to visually close a section.
Renders a single closing line matching the header style:
  Curved:  ╰──────────────╯
  Stars:   ****************
  Heavy:   ╚══════════════╝

-ForegroundColor takes either a [System.ConsoleColor] (or its string name), a 'rainbow' / '<base>-rainbow'
bareword, or a [Catzc.Base.Writers.RainbowColor] profile — the last three render the closing rule as a
per-character gradient.
```

## comment:2

Section `.PARAMETER ForegroundColor` of the comment-based help.

```text
Colour for the output: a [System.ConsoleColor] (or its name), a 'rainbow' / '<base>-rainbow' bareword, or a
[Catzc.Base.Writers.RainbowColor] profile — the last three give a gradient rule. No colour by default
(renders as terminal default).
```
