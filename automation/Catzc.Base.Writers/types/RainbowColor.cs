/*
---
catzc:
  immutable:
    path: automation/Catzc.Base.Writers/types/RainbowColor.cs
    folder: types
    name: rainbow-color
    filetype: cs
    kind: type
    language: csharp
    track: automation
    module: Catzc.Base.Writers
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    page: docs/references/automation/catzc-base-writers/types/RainbowColor.cs.md
    test: automation/Catzc.Base.Writers/tests/types/RainbowColor.Tests.ps1
    cites:
      - ADR-AUTO-CONSOLE
---
*/

using System;
using System.Text;

namespace Catzc.Base.Writers;

public sealed class RainbowColor
{
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

    private readonly int baseIndex;

    public RainbowColor(ConsoleColor baseColor)
    {
        Base = baseColor;
        baseIndex = Array.IndexOf(Ring, baseColor);
    }

    public ConsoleColor ColorAt(int index)
    {
        if (index <= 0) { return Base; }
        if (baseIndex >= 0) { return Ring[(baseIndex + index) % Ring.Length]; }
        return Ring[(index - 1) % Ring.Length];
    }

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
