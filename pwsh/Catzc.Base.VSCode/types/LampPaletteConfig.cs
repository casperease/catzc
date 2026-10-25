using System;
using System.Collections;
using System.Collections.Generic;

namespace Catzc.Base.VSCode;

public sealed class LampPaletteConfig : Catzc.Base.Objects.DictionaryRecord
{
    private const string Failed = "lamp-palette config validation failed:\n";

    // The one declaration of every range's shades; lamp-palette.yml overrides a shade, never restates it.
    private static readonly string[] Order = { "committed", "staged", "unstaged", "failed", "empty", "veto" };
    private static readonly Dictionary<string, Dictionary<string, string>> Defaults = new Dictionary<string, Dictionary<string, string>>(StringComparer.Ordinal)
    {
        ["committed"] = Range("#3fb950", "#1f6f3a", "#3fb950", "#3fb950", "#3fb950", "#3fb95026"),
        ["staged"] = Range("#546a85", "#546a85", "#546a85", "#7d93b0", "#546a85", "#546a8540"),
        ["unstaged"] = Range("#8fa3bd", "#8fa3bd", "#8fa3bd", "#b3c3d8", "#8fa3bd", "#8fa3bd26"),
        ["failed"] = Range("#f85149", "#f85149", "#f85149", "#f85149", "#f85149", "#f8514926"),
        ["empty"] = Range("#8c8c8c", "#6b6b6b", "#8c8c8c", "#8c8c8c", "#8c8c8c", "#8c8c8c26"),
        ["veto"] = Range("#c13ad1", "#c13ad1", "#c13ad1", "#c13ad1", "#c13ad1", "#c13ad126"),
    };

    // Every range, by name, in palette order.
    public IReadOnlyDictionary<string, LampPaletteRange> ranges { get; }

    public LampPaletteConfig(IDictionary raw)
    {
        List<string> errors = new List<string>();
        if (raw == null) { throw new ArgumentException(Failed + "the registry must be a mapping"); }

        foreach (object k in raw.Keys)
        {
            string key = k == null ? null : k.ToString();
            if (key != "ranges") { errors.Add(string.Format("unknown top-level key '{0}' (allowed: ranges)", key)); }
        }

        object value = raw.Contains("ranges") ? raw["ranges"] : null;
        IDictionary overrides = value as IDictionary;
        if (value != null && overrides == null) { errors.Add("'ranges' must be a mapping of range -> shades"); }
        if (overrides != null)
        {
            foreach (object k in overrides.Keys)
            {
                string key = k == null ? null : k.ToString();
                if (!Defaults.ContainsKey(key ?? ""))
                {
                    errors.Add(string.Format("unknown range '{0}' (allowed: {1})", key, string.Join(", ", Order)));
                }
            }
        }

        Dictionary<string, LampPaletteRange> map = new Dictionary<string, LampPaletteRange>(StringComparer.Ordinal);
        foreach (string name in Order)
        {
            object shades = overrides != null && overrides.Contains(name) ? overrides[name] : null;
            map[name] = new LampPaletteRange(name, Defaults[name], shades, errors);
        }

        if (errors.Count > 0) { throw new ArgumentException(Failed + string.Join("\n", errors)); }
        ranges = map;
    }

    private static Dictionary<string, string> Range(string lit, string unlit, string badge, string text, string mark, string background)
    {
        return new Dictionary<string, string>(StringComparer.Ordinal)
        {
            ["glyph_lit"] = lit,
            ["glyph_unlit"] = unlit,
            ["badge"] = badge,
            ["text"] = text,
            ["mark"] = mark,
            ["background"] = background,
        };
    }
}
