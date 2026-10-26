/*
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-writers/types/RainbowColor.cs.md"
  header: "generated"
---
*/

using System;
using System.Text;

namespace Catzc.Base.Writers;

// A gradient anchored on a base colour, which it becomes wherever only one colour is wanted.
public sealed class RainbowColor
{
    // Vivid hues only, DarkYellow standing in for orange, so no step lands on a colour unreadable on a dark ground.
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

    // -1 for a non-chromatic anchor, whose walk then starts at the ring's head.
    private readonly int baseIndex;

    public RainbowColor(ConsoleColor baseColor)
    {
        Base = baseColor;
        baseIndex = Array.IndexOf(Ring, baseColor);
    }

    // Char 0 is always the anchor; the walk goes on from it, or from the ring's head for a non-chromatic anchor.
    public ConsoleColor ColorAt(int index)
    {
        if (index <= 0) { return Base; }
        if (baseIndex >= 0) { return Ring[(baseIndex + index) % Ring.Length]; }
        return Ring[(index - 1) % Ring.Length];
    }

    // One reset for the whole run: a gradient belongs on a single-line rule.
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

    // Null for a token that is no rainbow, so a caller falls through to a ConsoleColor parse; it round-trips with ToString.
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

    // A profile is its base colour wherever one colour is wanted, so any ConsoleColor sink accepts it.
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
