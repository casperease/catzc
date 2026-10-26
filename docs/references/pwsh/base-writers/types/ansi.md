# pwsh/Base.Writers/types/Ansi.cs

The single source of the `ConsoleColor` to ANSI SGR foreground-escape map, shared by every writer that emits colour
([ADR-AUTO-CONSOLE-SPARINGCOLOUR](../../../../drs/automation/console-output-matters.md#rule-adr-auto-console-sparingcolour)).
`Write-InformationColored`, the writer chokepoint, resolves a colour's escape here instead of an inline switch, and `RainbowColor` builds
its per-character gradient from the same table, so the mapping lives once.

## The map

The codes are the normal and bright SGR foregrounds matching the 16 `System.ConsoleColor` values, indexed by the colour's integer value
(Black = 0 to White = 15). The enum's declaration order is not the ANSI order, so the table is a deliberate remap and never 30 plus the
index.

## Members

- **`Esc`** — the ESC control byte (0x1B) that opens every SGR sequence, built from its code point so the source carries no raw control
  character.
- **`Reset`** — the SGR reset that closes a coloured run. CI log renderers reset ANSI at newlines, so a multi-line caller re-opens the
  colour per line rather than spanning the newline.
- **`Code`** — the opening escape for a colour (for example `ESC[91m` for Red), or an empty string for an out-of-range value, so a caller
  can treat "no colour" as "pass the text through unchanged".
- **`Wrap`** — wraps one run of text in a colour and a reset. It is single-line by contract: multi-line wrapping stays the caller's concern,
  because only the caller knows whether its text is one logical line or several.
