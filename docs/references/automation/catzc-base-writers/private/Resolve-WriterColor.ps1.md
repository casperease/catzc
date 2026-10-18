---
catzc:
  immutable:
    with_body_sha: "4426264fdb44"
    repo_status: locked
    path: docs/references/automation/catzc-base-writers/private/Resolve-WriterColor.ps1.md
    folder: docs/references/automation/catzc-base-writers/private
    name: resolve-writer-color-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
---

# automation/Catzc.Base.Writers/private/Resolve-WriterColor.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Normalises a writer's -ForegroundColor argument into a colour plan — a plain ConsoleColor or a rainbow profile — shared by Write-Header and
Write-Footer.

### description

A header/footer accepts either a `[System.ConsoleColor]` (or its string name, e.g. 'Cyan') or a `[Catzc.Base.Writers.RainbowColor]` profile
on -ForegroundColor. This resolves the argument once:

- unbound -> no colour (render as terminal default)
- a RainbowColor -> the gradient plan; its rule lines take the per-character walk, its text uses the base colour (the profile side-grades to
  Base)
- a ConsoleColor -> a single colour for every line (the pre-rainbow behaviour)
- a rainbow string -> 'rainbow' or '`<base>-rainbow`' (the RainbowColor.ToString form) parses to a gradient plan, so a bareword
  -ForegroundColor rainbow works with no cast
- any other string -> parsed to a ConsoleColor (a bareword binds as a string against the `[object]` parameter, so 'Cyan' still works)

Returns a hashtable { HasColor; IsRainbow; Rainbow; Base }.

### parameter ForegroundColor

The raw argument (a ConsoleColor, its string name, or a RainbowColor). Ignored when -Bound is not set.

### parameter Bound

Whether the caller bound -ForegroundColor at all — an unbound call renders with no colour.

## comment:1

Above `if ($ForegroundColor -is [string]) {`, written with `#`.

```text
A 'rainbow' / '<base>-rainbow' bareword resolves to a gradient profile (the ToString round-trip); any
other string falls through to the plain ConsoleColor cast below.
```
