// A "<base>-rainbow" colour profile: a header/footer rule rendered as a gradient anchored on a base [System.ConsoleColor] — char 0 IS...
// [ADR-AUTO-CONSOLE#7](/docs/adr/automation/console-output-matters.md#rule-adr-auto-console7),
// [ADR-AUTO-CONSOLE](/docs/adr/automation/console-output-matters.md)
// [comment:1](/docs/references/automation/catzc-base-writers/types/RainbowColor.cs.md#comment1)

using System;
using System.Text;

namespace Catzc.Base.Writers;

public sealed class RainbowColor
{
    // The chromatic walk: a 7-hue rainbow over the vivid console colours only.
    // [comment:2](/docs/references/automation/catzc-base-writers/types/RainbowColor.cs.md#comment2)
    public static readonly ConsoleColor[] Ring =
    {
        ConsoleColor.Red,
        ConsoleColor.DarkYellow,
        ConsoleColor.Yellow,
        ConsoleColor.Green,
        ConsoleColor.Cyan,
        ConsoleColor.Blue,
        ConsoleColor.Magenta,
    };

    // The anchor colour — char 0, and the colour this profile side-grades to.
    public ConsoleColor Base { get; }

    // The anchor's index in the chromatic ring, or -1 when the anchor is non-chromatic (its walk then starts at the head of the ring...
    // [comment:3](/docs/references/automation/catzc-base-writers/types/RainbowColor.cs.md#comment3)
    private readonly int baseIndex;

    public RainbowColor(ConsoleColor baseColor)
    {
        Base = baseColor;
        baseIndex = Array.IndexOf(Ring, baseColor);
    }

    // The colour of the character at position index.
    // [comment:4](/docs/references/automation/catzc-base-writers/types/RainbowColor.cs.md#comment4)
    public ConsoleColor ColorAt(int index)
    {
        if (index <= 0) { return Base; }
        if (baseIndex >= 0) { return Ring[(baseIndex + index) % Ring.Length]; }
        return Ring[(index - 1) % Ring.Length];
    }

    // Render text as the gradient: each character carries its ColorAt colour, one trailing reset.
    // [comment:5](/docs/references/automation/catzc-base-writers/types/RainbowColor.cs.md#comment5)
    public string Wrap(string text)
    {
        if (string.IsNullOrEmpty(text)) { return text; }
        StringBuilder builder = new StringBuilder(text.Length * 8);
        for (int i = 0; i < text.Length; i++)
        {
            builder.Append(Ansi.Code(ColorAt(i))).Append(text[i]);
        }
        builder.Append(Ansi.Reset);
        return builder.ToString();
    }

    // The inverse of ToString: parse a rainbow token into a profile, or return null when the text is not one (so a caller can fall...
    // [comment:6](/docs/references/automation/catzc-base-writers/types/RainbowColor.cs.md#comment6)
    public static RainbowColor FromString(string text)
    {
        if (string.IsNullOrWhiteSpace(text)) { return null; }
        string token = text.Trim();
        if (string.Equals(token, "rainbow", StringComparison.OrdinalIgnoreCase))
        {
            return new RainbowColor(Ring[0]);
        }
        const string suffix = "-rainbow";
        if (token.Length > suffix.Length && token.EndsWith(suffix, StringComparison.OrdinalIgnoreCase))
        {
            string basePart = token.Substring(0, token.Length - suffix.Length);
            if (Enum.TryParse(basePart, ignoreCase: true, out ConsoleColor baseColor)
                && Enum.IsDefined(typeof(ConsoleColor), baseColor))
            {
                return new RainbowColor(baseColor);
            }
        }
        return null;
    }

    // Side-grade: when only one colour is needed, a profile IS its base colour.
    // [comment:7](/docs/references/automation/catzc-base-writers/types/RainbowColor.cs.md#comment7)
    public static implicit operator ConsoleColor(RainbowColor profile)
    {
        if (profile == null) { throw new ArgumentNullException(nameof(profile)); }
        return profile.Base;
    }

    public override string ToString()
    {
        return Base.ToString().ToLowerInvariant() + "-rainbow";
    }
}
