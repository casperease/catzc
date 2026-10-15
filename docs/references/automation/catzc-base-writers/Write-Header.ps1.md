---
catzc:
  derived:
    path: docs/references/automation/catzc-base-writers/Write-Header.ps1.md
    kind: reference
    body_sha: bcb7b12de183
    adrs: []
---

# automation/Catzc.Base.Writers/Write-Header.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Styles (with message / without message):

  Curved (default):
    ╭──────────────╮       ╭──────────────╮
    │ Message      │
    ╰──────────────╯

  Stars:
    ****************       ****************
    * Message
    ****************

-ForegroundColor takes either a [System.ConsoleColor] (or its string name) — one colour for the whole
header — or a [Catzc.Base.Writers.RainbowColor] profile, which renders the horizontal rule lines as a
per-character gradient while the titled line keeps the profile's base colour. The gradient is also
reachable as a bareword: 'rainbow' (anchored on the ring head, a full chromatic walk) or '<base>-rainbow'
(e.g. 'green-rainbow', the RainbowColor.ToString form). A profile passed to any plain [ConsoleColor] sink
side-grades to its base, so the same value works everywhere.
```

## comment:2

Section `.PARAMETER ForegroundColor` of the comment-based help.

```text
Colour for the output: a [System.ConsoleColor] (or its name), a 'rainbow' / '<base>-rainbow' bareword, or a
[Catzc.Base.Writers.RainbowColor] profile — the last three give a gradient rule. No colour by default
(renders as terminal default).
```
