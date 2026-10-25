# pwsh/Catzc.Base.Writers/types/RainbowColor.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `public sealed class RainbowColor`, written with `//`.

```text
A "<base>-rainbow" colour profile
([ADR-AUTO-CONSOLE-SPARINGCOLOUR](/docs/drs/automation/console-output-matters.md#rule-adr-auto-console-sparingcolour)): a header/footer rule rendered
as a gradient anchored on
a base [System.ConsoleColor] — char 0 IS the base, and each subsequent char steps forward along a fixed
CHROMATIC ring of the console colours (dark/neutral colours never appear in the walk, so the gradient stays
legible on a dark ground even when the anchor is a dark colour). When only one colour is needed the profile
side-grades to its base via an implicit ConsoleColor conversion, so every single-colour sink (Write-Message,
any [ConsoleColor] parameter) keeps working unchanged. Green-rainbow is the passed-run celebration; the
profile is reusable for any anchor. See [ADR-AUTO-CONSOLE](/docs/drs/automation/console-output-matters.md).
```

## comment:2

Above `public static readonly ConsoleColor[] Ring =`, written with `//`.

```text
The chromatic walk: a 7-hue rainbow over the vivid console colours only. DarkYellow stands in for orange
(the console palette has no brighter orange). Neutrals (Black/Gray/White) and the dark blues are
deliberately absent, so a step never lands on an unreadable colour on a dark terminal (the ring-order
decision: chromatic-only stepping). The anchor may still be any colour — only the WALK is constrained.
```

## comment:3

Above `private readonly int baseIndex;`, written with `//`.

```text
The anchor's index in the chromatic ring, or -1 when the anchor is non-chromatic (its walk then starts
at the head of the ring rather than continuing from the anchor).
```

## comment:4

Above `public ConsoleColor ColorAt(int index)`, written with `//`.

```text
The colour of the character at position index. char 0 is always the literal anchor; a chromatic anchor
then continues along the ring from its own position (green -> cyan -> blue -> ...), a non-chromatic
anchor walks from the ring head (black -> red -> orange -> ...).
```

## comment:5

Above `public string Wrap(string text)`, written with `//`.

```text
Render text as the gradient: each character carries its ColorAt colour, one trailing reset. Intended for
a single-line rule (a header/footer border) — the only place a gradient is drawn. Empty in, empty out.
```

## comment:6

Above `public static RainbowColor FromString(string text)`, written with `//`.

```text
The inverse of ToString: parse a rainbow token into a profile, or return null when the text is not one
(so a caller can fall through to a plain ConsoleColor parse). "rainbow" anchors on the ring head (Red),
so it walks the full chromatic ring; "<base>-rainbow" (the ToString form) anchors on that base, so the
string round-trips. Matching is case-insensitive, matching how a ConsoleColor name parses.
```

## comment:7

Above `public static implicit operator ConsoleColor(RainbowColor profile)`, written with `//`.

```text
Side-grade: when only one colour is needed, a profile IS its base colour. This is what lets a profile be
passed to any [ConsoleColor] sink (Write-Message, a plain -ForegroundColor) and degrade cleanly.
```
