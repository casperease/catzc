---
catzc:
  derived:
    path: docs/references/automation/catzc-base-writers/private/Resolve-WriterColor.ps1.md
    kind: comment-page
    body_sha: "194549d2092d"
    adrs: []
---

# automation/Catzc.Base.Writers/private/Resolve-WriterColor.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
A header/footer accepts either a [System.ConsoleColor] (or its string name, e.g. 'Cyan') or a
[Catzc.Base.Writers.RainbowColor] profile on -ForegroundColor. This resolves the argument once:

  - unbound            -> no colour (render as terminal default)
  - a RainbowColor     -> the gradient plan; its rule lines take the per-character walk, its text uses
                          the base colour (the profile side-grades to Base)
  - a ConsoleColor     -> a single colour for every line (the pre-rainbow behaviour)
  - a rainbow string   -> 'rainbow' or '<base>-rainbow' (the RainbowColor.ToString form) parses to a
                          gradient plan, so a bareword -ForegroundColor rainbow works with no cast
  - any other string   -> parsed to a ConsoleColor (a bareword binds as a string against the [object]
                          parameter, so 'Cyan' still works)

Returns a hashtable { HasColor; IsRainbow; Rainbow; Base }.
```

## comment:2

Above `if ($ForegroundColor -is [string]) {`.

```text
A 'rainbow' / '<base>-rainbow' bareword resolves to a gradient profile (the ToString round-trip); any
other string falls through to the plain ConsoleColor cast below.
```
