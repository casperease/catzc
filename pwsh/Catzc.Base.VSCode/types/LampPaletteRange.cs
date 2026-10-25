using System;
using System.Collections;
using System.Collections.Generic;
using System.Text.RegularExpressions;

namespace Catzc.Base.VSCode;

public sealed class LampPaletteRange
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    public static readonly string[] Shades = { "glyph_lit", "glyph_unlit", "badge", "text", "mark", "background" };
    private static readonly Regex Hex = new Regex("^#[0-9a-fA-F]{6}([0-9a-fA-F]{2})?$", RegexOptions.CultureInvariant);

    // The range name (committed, staged, unstaged, failed, empty, veto).
    public string name { get; }

    // The lit lamp glyph.
    public string glyph_lit { get; }

    // The unlit lamp glyph.
    public string glyph_unlit { get; }

    // The condition badge on a lamp icon.
    public string badge { get; }

    // The file-name text in the Explorer.
    public string text { get; }

    // The gutter, overview-ruler and minimap marks.
    public string mark { get; }

    // The line background, alpha included.
    public string background { get; }

    // Each shade the override omits keeps its default; an override is a mapping of shade -> #rrggbb[aa].
    public LampPaletteRange(string name, IReadOnlyDictionary<string, string> defaults, object overrides, List<string> errors)
    {
        this.name = name;
        Dictionary<string, string> shades = new Dictionary<string, string>(defaults, StringComparer.Ordinal);

        IDictionary map = overrides as IDictionary;
        if (overrides != null && map == null) { errors.Add(string.Format("range '{0}' must be a mapping of shades", name)); }
        if (map != null)
        {
            foreach (object k in map.Keys)
            {
                string key = k == null ? null : k.ToString();
                if (Array.IndexOf(Shades, key) < 0)
                {
                    errors.Add(string.Format("range '{0}': unknown shade '{1}' (allowed: {2})", name, key, string.Join(", ", Shades)));
                    continue;
                }
                string value = map[k] as string;
                if (value == null || !Hex.IsMatch(value))
                {
                    errors.Add(string.Format("range '{0}': shade '{1}' must be #rrggbb or #rrggbbaa, got '{2}'", name, key, map[k]));
                    continue;
                }
                shades[key] = value.ToLowerInvariant();
            }
        }

        glyph_lit = shades["glyph_lit"];
        glyph_unlit = shades["glyph_unlit"];
        badge = shades["badge"];
        text = shades["text"];
        mark = shades["mark"];
        background = shades["background"];
    }
}
