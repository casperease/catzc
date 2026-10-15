/*
---
catzc:
  derived:
    path: automation/Catzc.Base.Writers/types/Ansi.cs
    kind: type
    module: Catzc.Base.Writers
    adrs:
      - ADR-AUTO-CONSOLE#7
---
*/

// The one colour-to-escape table: Write-InformationColored and RainbowColor both read it, so no inline switch can drift.
// [comment:1](/docs/references/automation/catzc-base-writers/types/Ansi.cs.md#comment1)

using System;

namespace Catzc.Base.Writers;

public static class Ansi
{
    // Built from its code point, not an escape literal, so the source carries no raw control character.
    // [comment:2](/docs/references/automation/catzc-base-writers/types/Ansi.cs.md#comment2)
    private const char Esc = (char)27;

    // CI log renderers reset ANSI at newlines, so a multi-line caller re-opens the colour per line.
    // [comment:3](/docs/references/automation/catzc-base-writers/types/Ansi.cs.md#comment3)
    public static readonly string Reset = Esc + "[0m";

    // The enum order is not the ANSI order, so this is a deliberate remap and not 30 plus the index.
    // [comment:4](/docs/references/automation/catzc-base-writers/types/Ansi.cs.md#comment4)
    private static readonly int[] Codes =
    {
        30, // 0  Black
        34, // 1  DarkBlue
        32, // 2  DarkGreen
        36, // 3  DarkCyan
        31, // 4  DarkRed
        35, // 5  DarkMagenta
        33, // 6  DarkYellow
        37, // 7  Gray
        90, // 8  DarkGray
        94, // 9  Blue
        92, // 10 Green
        96, // 11 Cyan
        91, // 12 Red
        95, // 13 Magenta
        93, // 14 Yellow
        97, // 15 White
    };

    // An out-of-range value gives an empty string, so a caller can treat no colour as pass the text through.
    // [comment:5](/docs/references/automation/catzc-base-writers/types/Ansi.cs.md#comment5)
    public static string Code(ConsoleColor color)
    {
        int i = (int)color;
        if (i < 0 || i >= Codes.Length) { return string.Empty; }
        return Esc + "[" + Codes[i].ToString() + "m";
    }

    // Single-line by contract: only the caller knows whether its text is one logical line or several.
    // [comment:6](/docs/references/automation/catzc-base-writers/types/Ansi.cs.md#comment6)
    public static string Wrap(string text, ConsoleColor color)
    {
        string code = Code(color);
        return code.Length == 0 ? text : code + text + Reset;
    }
}
