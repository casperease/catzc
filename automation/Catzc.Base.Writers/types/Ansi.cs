// Single source of the ConsoleColor -> ANSI SGR foreground-escape map, shared by every writer that emits
// color. Write-InformationColored (the writer chokepoint) resolves a colour's escape here instead of an
// inline switch, and RainbowColor builds its per-character gradient from the same table — so the mapping
// lives once. Codes are the normal/bright SGR foregrounds matching the 16 [System.ConsoleColor] values.
// See docs/adr/automation/powershell/console-output-matters.md (ADR-CONSOLE:7).

using System;

namespace Catzc.Base.Writers;

public static class Ansi
{
    // The ESC control byte (0x1B) that opens every SGR sequence. Built from its code point rather than an
    // escape literal so the source carries no raw control character.
    private const char Esc = (char)27;

    // SGR reset — closes a coloured run. CI log renderers reset ANSI at newlines, so a multi-line caller
    // re-opens the colour per line rather than spanning the newline.
    public static readonly string Reset = Esc + "[0m";

    // SGR foreground code per ConsoleColor, indexed by (int)color (Black = 0 .. White = 15). The enum's
    // declaration order is NOT the ANSI order, so this is a deliberate remap, not (30 + index).
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

    // The opening escape for a colour (e.g. ESC[91m for Red); empty string for an out-of-range value,
    // so a caller can treat "no colour" as "pass the text through unchanged".
    public static string Code(ConsoleColor color)
    {
        int i = (int)color;
        if (i < 0 || i >= Codes.Length) { return string.Empty; }
        return Esc + "[" + Codes[i].ToString() + "m";
    }

    // Wrap one run of text in a colour and reset. Single-line by contract: multi-line wrapping (re-opening
    // the colour per line for CI) stays the caller's concern, because only the caller knows whether its text
    // is one logical line or several.
    public static string Wrap(string text, ConsoleColor color)
    {
        string code = Code(color);
        return code.Length == 0 ? text : code + text + Reset;
    }
}
