using System;

namespace Catzc.Base.Writers;

// One ConsoleColor-to-SGR map, so every coloured writer emits the same escape for a colour.
public static class Ansi
{
    // Built from its code point, so the source holds no raw control character.
    private const char Esc = (char)27;

    // CI logs reset colour at a newline, so a multi-line run re-opens its colour on each line.
    public static readonly string Reset = Esc + "[0m";

    // ConsoleColor's order is not ANSI's, so this is a remap, never 30 plus the index.
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

    // Empty for an out-of-range value, so no colour means the text passes through unchanged.
    public static string Code(ConsoleColor color)
    {
        int i = (int)color;
        if (i < 0 || i >= Codes.Length) { return string.Empty; }
        return Esc + "[" + Codes[i].ToString() + "m";
    }

    // One line only: whether text is one logical line or several is the caller's to know.
    public static string Wrap(string text, ConsoleColor color)
    {
        string code = Code(color);
        return code.Length == 0 ? text : code + text + Reset;
    }
}
