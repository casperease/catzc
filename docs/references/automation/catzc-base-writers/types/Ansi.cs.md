---
catzc:
  derived:
    path: docs/references/automation/catzc-base-writers/types/Ansi.cs.md
    folder: docs/references/automation/catzc-base-writers/types
    name: ansi-cs
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "3377702bc161"
    adrs:
      - ADR-AUTO-CONSOLE#7
---

# automation/Catzc.Base.Writers/types/Ansi.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
Single source of the ConsoleColor -> ANSI SGR foreground-escape map, shared by every writer that emits
color. Write-InformationColored (the writer chokepoint) resolves a colour's escape here instead of an
inline switch, and RainbowColor builds its per-character gradient from the same table — so the mapping
lives once. Codes are the normal/bright SGR foregrounds matching the 16 [System.ConsoleColor] values.
See [ADR-AUTO-CONSOLE#7](/docs/adr/automation/console-output-matters.md#rule-adr-auto-console7).
```

## comment:2

Above `private const char Esc = (char)27;`, written with `//`.

```text
The ESC control byte (0x1B) that opens every SGR sequence. Built from its code point rather than an
escape literal so the source carries no raw control character.
```

## comment:3

Above `public static readonly string Reset = Esc + "[0m";`, written with `//`.

```text
SGR reset — closes a coloured run. CI log renderers reset ANSI at newlines, so a multi-line caller
re-opens the colour per line rather than spanning the newline.
```

## comment:4

Above `private static readonly int[] Codes =`, written with `//`.

```text
SGR foreground code per ConsoleColor, indexed by (int)color (Black = 0 .. White = 15). The enum's
declaration order is NOT the ANSI order, so this is a deliberate remap, not (30 + index).
```

## comment:5

Above `public static string Code(ConsoleColor color)`, written with `//`.

```text
The opening escape for a colour (e.g. ESC[91m for Red); empty string for an out-of-range value,
so a caller can treat "no colour" as "pass the text through unchanged".
```

## comment:6

Above `public static string Wrap(string text, ConsoleColor color)`, written with `//`.

```text
Wrap one run of text in a colour and reset. Single-line by contract: multi-line wrapping (re-opening
the colour per line for CI) stays the caller's concern, because only the caller knows whether its text
is one logical line or several.
```
