using System.Collections.Generic;

namespace Catzc.Base.Maps;

// The only text the base-14 fonts can show: ASCII 0x20-0x7E, Latin-1 0xA0-0xFF, and 27 typographic characters at 0x80-0x9F.
public static class WinAnsi
{
    // The 0x80-0x9F codes and the Unicode characters they show. 0x81, 0x8D, 0x8F, 0x90 and 0x9D are undefined.
    private static readonly Dictionary<char, int> Typographic = new Dictionary<char, int>
    {
        { '€', 0x80 }, { '‚', 0x82 }, { 'ƒ', 0x83 }, { '„', 0x84 }, { '…', 0x85 },
        { '†', 0x86 }, { '‡', 0x87 }, { 'ˆ', 0x88 }, { '‰', 0x89 }, { 'Š', 0x8A },
        { '‹', 0x8B }, { 'Œ', 0x8C }, { 'Ž', 0x8E }, { '‘', 0x91 }, { '’', 0x92 },
        { '“', 0x93 }, { '”', 0x94 }, { '•', 0x95 }, { '–', 0x96 }, { '—', 0x97 },
        { '˜', 0x98 }, { '™', 0x99 }, { 'š', 0x9A }, { '›', 0x9B }, { 'œ', 0x9C },
        { 'ž', 0x9E }, { 'Ÿ', 0x9F },
    };

    // The WinAnsi code of a character, or -1 when the character has none (or is a control character).
    public static int CodeOf(char c)
    {
        if (c >= ' ' && c <= '~') { return c; }
        if (c >= ' ' && c <= 'ÿ') { return c; }
        int code;
        return Typographic.TryGetValue(c, out code) ? code : -1;
    }

    // The first character with no WinAnsi code, or -1; an empty or null text has none.
    public static int IndexOfUnsupported(string text)
    {
        if (string.IsNullOrEmpty(text)) { return -1; }
        for (int i = 0; i < text.Length; i++)
        {
            if (CodeOf(text[i]) < 0) { return i; }
        }
        return -1;
    }

    // True when every character of the text has a WinAnsi code.
    public static bool IsEncodable(string text) => IndexOfUnsupported(text) < 0;
}
