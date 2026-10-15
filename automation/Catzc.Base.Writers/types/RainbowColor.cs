/*
---
catzc:
  derived:
    path: automation/Catzc.Base.Writers/types/RainbowColor.cs
    kind: type
    module: Catzc.Base.Writers
    adrs:
      - ADR-AUTO-CONSOLE
      - ADR-AUTO-CONSOLE#7
---
*/

// Char 0 is the anchor and later chars walk a chromatic ring, so a dark anchor still gives a legible gradient.
// [comment:1](/docs/references/automation/catzc-base-writers/types/RainbowColor.cs.md#comment1)

using System;
using System.Text;

namespace Catzc.Base.Writers;

public sealed class RainbowColor
{
    // Neutrals and dark blues are left out so no step lands on an unreadable colour; DarkYellow stands in for orange.
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

    // Minus one marks a non-chromatic anchor, whose walk starts at the ring head instead of continuing from the anchor.
    // [comment:3](/docs/references/automation/catzc-base-writers/types/RainbowColor.cs.md#comment3)
    private readonly int baseIndex;

    public RainbowColor(ConsoleColor baseColor)
    {
        Base = baseColor;
        baseIndex = Array.IndexOf(Ring, baseColor);
    }

    // Char 0 is always the literal anchor, so a chromatic anchor continues from its own ring position afterwards.
    // [comment:4](/docs/references/automation/catzc-base-writers/types/RainbowColor.cs.md#comment4)
    public ConsoleColor ColorAt(int index)
    {
        if (index <= 0) { return Base; }
        if (baseIndex >= 0) { return Ring[(baseIndex + index) % Ring.Length]; }
        return Ring[(index - 1) % Ring.Length];
    }

    // Meant for a single-line rule only, since a header or footer border is the one place a gradient is drawn.
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

    // Null for a non-rainbow text lets the caller fall through to a plain ConsoleColor parse; matching ignores case.
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

    // This implicit conversion lets a profile reach any ConsoleColor sink and degrade cleanly to a single colour.
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
