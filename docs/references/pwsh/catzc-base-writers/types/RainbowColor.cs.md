# pwsh/Base.Writers/types/RainbowColor.cs

A `<base>-rainbow` colour profile
([ADR-AUTO-CONSOLE-SPARINGCOLOUR](../../../../drs/automation/console-output-matters.md#rule-adr-auto-console-sparingcolour),
[ADR-AUTO-CONSOLE](../../../../drs/automation/console-output-matters.md)): a header or footer rule rendered as a gradient anchored on a base
`System.ConsoleColor`. Char 0 is the base, and each following char steps forward along a fixed chromatic ring of the console colours.
Green-rainbow is the passed-run celebration, and the profile is reusable for any anchor.

## The ring

The walk is a seven-hue rainbow over the vivid console colours only, with DarkYellow standing in for orange since the console palette has no
brighter orange. Neutrals (Black, Gray, White) and the dark blues are deliberately absent, so a step never lands on an unreadable colour on
a dark terminal. The anchor may still be any colour; only the walk is constrained.

## Walking from the anchor

The anchor's index in the ring is kept, or -1 when the anchor is non-chromatic. `ColorAt` gives char 0 the literal anchor. A chromatic
anchor then continues along the ring from its own position (green, cyan, blue, ...); a non-chromatic anchor walks from the ring head (black,
red, orange, ...).

## Rendering and parsing

- **`Wrap`** — renders text as the gradient: each character carries its `ColorAt` colour, with one trailing reset. It is meant for a
  single-line rule, the only place a gradient is drawn. Empty in, empty out.
- **`FromString`** — the inverse of `ToString`: it parses a rainbow token into a profile, or returns null when the text is not one, so a
  caller can fall through to a plain `ConsoleColor` parse. `rainbow` anchors on the ring head (Red) and walks the full ring;
  `<base>-rainbow` anchors on that base, so the string round-trips. Matching is case-insensitive, as a `ConsoleColor` name parses.

## Side-grade

An implicit conversion to `ConsoleColor` makes a profile its base colour wherever one colour is wanted. A profile therefore passes to any
`ConsoleColor` sink (`Write-Message`, a plain `-ForegroundColor`) and degrades cleanly.
