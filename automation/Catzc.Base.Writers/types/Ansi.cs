// Single source of the ConsoleColor -> ANSI SGR foreground-escape map, shared by every writer that emits color.
// [ADR-AUTO-CONSOLE#7](/docs/adr/automation/console-output-matters.md#rule-adr-auto-console7)
// [comment:1](/docs/references/automation/catzc-base-writers/types/Ansi.cs.md#comment1)

using System;

namespace Catzc.Base.Writers;

public static class Ansi
{
    // The ESC control byte (0x1B) that opens every SGR sequence.
    // [comment:2](/docs/references/automation/catzc-base-writers/types/Ansi.cs.md#comment2)
    private const char Esc = (char)27;

    // SGR reset — closes a coloured run.
    // [comment:3](/docs/references/automation/catzc-base-writers/types/Ansi.cs.md#comment3)
    public static readonly string Reset = Esc + "[0m";

    // SGR foreground code per ConsoleColor, indexed by (int)color (Black = 0..
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

    // The opening escape for a colour (e.g.
    // [comment:5](/docs/references/automation/catzc-base-writers/types/Ansi.cs.md#comment5)
    public static string Code(ConsoleColor color)
    {
        int i = (int)color;
        if (i < 0 || i >= Codes.Length) { return string.Empty; }
        return Esc + "[" + Codes[i].ToString() + "m";
    }

    // Wrap one run of text in a colour and reset.
    // [comment:6](/docs/references/automation/catzc-base-writers/types/Ansi.cs.md#comment6)
    public static string Wrap(string text, ConsoleColor color)
    {
        string code = Code(color);
        return code.Length == 0 ? text : code + text + Reset;
    }
}
