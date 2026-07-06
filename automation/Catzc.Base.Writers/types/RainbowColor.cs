// A "<base>-rainbow" colour profile (ADR-CONSOLE:7): a header/footer rule rendered as a gradient anchored on
// a base [System.ConsoleColor] — char 0 IS the base, and each subsequent char steps forward along a fixed
// CHROMATIC ring of the console colours (dark/neutral colours never appear in the walk, so the gradient stays
// legible on a dark ground even when the anchor is a dark colour). When only one colour is needed the profile
// side-grades to its base via an implicit ConsoleColor conversion, so every single-colour sink (Write-Message,
// any [ConsoleColor] parameter) keeps working unchanged. Green-rainbow is the passed-run celebration; the
// profile is reusable for any anchor. See docs/adr/automation/powershell/console-output-matters.md.

using System;
using System.Text;

namespace Catzc.Base.Writers;

public sealed class RainbowColor
{
    // The chromatic walk: a 7-hue rainbow over the vivid console colours only. DarkYellow stands in for orange
    // (the console palette has no brighter orange). Neutrals (Black/Gray/White) and the dark blues are
    // deliberately absent, so a step never lands on an unreadable colour on a dark terminal (the ring-order
    // decision: chromatic-only stepping). The anchor may still be any colour — only the WALK is constrained.
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

    // The anchor's index in the chromatic ring, or -1 when the anchor is non-chromatic (its walk then starts
    // at the head of the ring rather than continuing from the anchor).
    private readonly int baseIndex;

    public RainbowColor(ConsoleColor baseColor)
    {
        Base = baseColor;
        baseIndex = Array.IndexOf(Ring, baseColor);
    }

    // The colour of the character at position index. char 0 is always the literal anchor; a chromatic anchor
    // then continues along the ring from its own position (green -> cyan -> blue -> ...), a non-chromatic
    // anchor walks from the ring head (black -> red -> orange -> ...).
    public ConsoleColor ColorAt(int index)
    {
        if (index <= 0) { return Base; }
        if (baseIndex >= 0) { return Ring[(baseIndex + index) % Ring.Length]; }
        return Ring[(index - 1) % Ring.Length];
    }

    // Render text as the gradient: each character carries its ColorAt colour, one trailing reset. Intended for
    // a single-line rule (a header/footer border) — the only place a gradient is drawn. Empty in, empty out.
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

    // Side-grade: when only one colour is needed, a profile IS its base colour. This is what lets a profile be
    // passed to any [ConsoleColor] sink (Write-Message, a plain -ForegroundColor) and degrade cleanly.
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
