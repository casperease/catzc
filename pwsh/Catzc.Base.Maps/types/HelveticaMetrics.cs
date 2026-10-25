/*
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-maps/types/HelveticaMetrics.cs.md"
  warning: "Generated Header"
---
*/

using System;

namespace Catzc.Base.Maps;

public static class HelveticaMetrics
{
    // The width of characters the tables do not list, in thousandths: wide enough for every WinAnsi glyph.
    public const int FallbackWidth = 1000;

    // Helvetica, ' ' (0x20) to '~' (0x7E).
    private static readonly int[] Regular =
    {
        278, 278, 355, 556, 556, 889, 667, 191, 333, 333, 389, 584, 278, 333, 278, 278,
        556, 556, 556, 556, 556, 556, 556, 556, 556, 556, 278, 278, 584, 584, 584, 556,
        1015, 667, 667, 722, 722, 667, 611, 778, 722, 278, 500, 667, 556, 833, 722, 778,
        667, 778, 722, 667, 611, 722, 667, 944, 667, 667, 611, 278, 278, 278, 469, 556,
        333, 556, 556, 500, 556, 556, 278, 556, 556, 222, 222, 500, 222, 833, 556, 556,
        556, 556, 333, 500, 278, 556, 500, 722, 500, 500, 500, 334, 260, 334, 584
    };

    // Helvetica-Bold, ' ' (0x20) to '~' (0x7E).
    private static readonly int[] Bold =
    {
        278, 333, 474, 556, 556, 889, 722, 238, 333, 333, 389, 584, 278, 333, 278, 278,
        556, 556, 556, 556, 556, 556, 556, 556, 556, 556, 333, 333, 584, 584, 584, 611,
        975, 722, 722, 722, 722, 667, 611, 778, 722, 278, 556, 722, 611, 833, 722, 778,
        667, 778, 722, 667, 611, 722, 667, 944, 667, 667, 611, 333, 278, 333, 584, 556,
        333, 556, 611, 556, 611, 556, 333, 611, 611, 278, 278, 556, 278, 889, 611, 611,
        611, 611, 389, 556, 333, 611, 556, 778, 556, 556, 500, 389, 280, 389, 584
    };

    // The width of one character, in thousandths of the font size.
    public static int CharWidth(PdfFont font, char c)
    {
        int[] table = font == PdfFont.HelveticaBold ? Bold : Regular;
        if (c >= ' ' && c <= '~') { return table[c - ' ']; }
        switch (c)
        {
            case '×': return 584;
            case '·': return 278;
            case '…': return 1000;
            default: return FallbackWidth;
        }
    }

    // The width of a text at a font size, in points.
    public static double Width(PdfFont font, double size, string text)
    {
        if (text == null) { throw new ArgumentNullException(nameof(text)); }
        long units = 0;
        foreach (char c in text) { units += CharWidth(font, c); }
        return units * size / 1000.0;
    }
}
