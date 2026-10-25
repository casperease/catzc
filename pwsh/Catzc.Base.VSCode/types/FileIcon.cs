using System;
using System.Collections;
using System.Collections.Generic;
using System.Text.RegularExpressions;

namespace Catzc.Base.VSCode;

public sealed class FileIcon
{
    private static readonly string[] AllowedKeys = { "glyph", "label", "style", "color", "language", "extensions", "names", "language_ids" };
    private static readonly string[] Styles = { "text", "prompt" };
    private static readonly Regex IconName = new Regex("^[a-z0-9][a-z0-9-]*$", RegexOptions.CultureInvariant);
    private static readonly Regex Hex = new Regex("^#[0-9a-fA-F]{6}$", RegexOptions.CultureInvariant);
    private static readonly Regex Label = new Regex(@"^\S{1,4}$", RegexOptions.CultureInvariant);

    // The icon's name: its id in the theme and its SVG file name.
    public string name { get; }

    // A lamp glyph of catzc-track-lamps (js/catzc-track-lamps/assets/<glyph>-on.svg), recoloured; null when the icon is a label.
    public string glyph { get; }

    // One to four characters without spaces, drawn as the icon; null when the icon is a glyph.
    public string label { get; }

    // How a label is drawn: text, the characters alone; prompt, the characters over a console chevron. Defaults to text.
    public string style { get; }

    // The icon's colour, a six-digit hex colour.
    public string color { get; }

    // A language of languages.yml whose extensions the icon marks, except those another icon names itself; null when it names none.
    public string language { get; }

    // The file extensions it marks, without the leading dot; a compound one (drawio.png, tests.ps1) is matched before its last part.
    public string[] extensions { get; }

    // The exact file names it marks (.gitignore, LICENSE).
    public string[] names { get; }

    // The VS Code language ids it marks, for files an association or an extension gives a language (github-actions-workflow).
    public string[] language_ids { get; }

    public FileIcon(string name, object raw, List<string> errors)
    {
        this.name = name;
        if (name == null || !IconName.IsMatch(name)) { errors.Add(string.Format("icon name '{0}' must be lower-case letters, digits and hyphens", name)); }
        IDictionary entry = raw as IDictionary;
        if (entry == null)
        {
            errors.Add(string.Format("icon '{0}' must be a mapping", name));
            extensions = new string[0];
            names = new string[0];
            language_ids = new string[0];
            return;
        }
        foreach (object k in entry.Keys)
        {
            string key = k == null ? null : k.ToString();
            if (Array.IndexOf(AllowedKeys, key) < 0) { errors.Add(string.Format("icon '{0}': unknown key '{1}' (allowed: {2})", name, key, string.Join(", ", AllowedKeys))); }
        }

        glyph = entry.Contains("glyph") ? entry["glyph"] as string : null;
        label = entry.Contains("label") ? entry["label"] as string : null;
        if ((glyph == null) == (label == null)) { errors.Add(string.Format("icon '{0}' needs exactly one of 'glyph' or 'label'", name)); }
        if (glyph != null && !IconName.IsMatch(glyph)) { errors.Add(string.Format("icon '{0}': glyph '{1}' is not a lamp glyph name", name, glyph)); }
        if (label != null && !Label.IsMatch(label)) { errors.Add(string.Format("icon '{0}': label '{1}' must be 1-4 characters without spaces", name, label)); }

        style = entry.Contains("style") ? entry["style"] as string : "text";
        if (Array.IndexOf(Styles, style) < 0) { errors.Add(string.Format("icon '{0}': style '{1}' is unknown (allowed: {2})", name, style, string.Join(", ", Styles))); }
        if (glyph != null && entry.Contains("style")) { errors.Add(string.Format("icon '{0}': 'style' applies to a label only", name)); }

        color = entry.Contains("color") ? entry["color"] as string : null;
        if (color == null || !Hex.IsMatch(color)) { errors.Add(string.Format("icon '{0}': color '{1}' must be a six-digit hex colour", name, color)); }
        else
        {
            color = color.ToLowerInvariant();
            if (IsRed(color)) { errors.Add(string.Format("icon '{0}': color '{1}' is a red, which marks an error only", name, color)); }
        }

        extensions = List(entry, "extensions", errors);
        for (int i = 0; i < extensions.Length; i++)
        {
            if (extensions[i].StartsWith(".", StringComparison.Ordinal)) { extensions[i] = extensions[i].Substring(1); }
            extensions[i] = extensions[i].ToLowerInvariant();
        }
        names = List(entry, "names", errors);
        language_ids = List(entry, "language_ids", errors);
        language = entry.Contains("language") ? entry["language"] as string : null;
        if (entry.Contains("language") && string.IsNullOrWhiteSpace(language)) { errors.Add(string.Format("icon '{0}': 'language' must be a language name", name)); }
        if (language == null && extensions.Length == 0 && names.Length == 0 && language_ids.Length == 0)
        {
            errors.Add(string.Format("icon '{0}' marks no file: give 'language', 'extensions', 'names' or 'language_ids'", name));
        }
    }

    // A colour is red when its hue lies within 20 degrees of pure red and it is saturated enough to read as a colour, not a grey.
    private static bool IsRed(string hex)
    {
        double r = Convert.ToInt32(hex.Substring(1, 2), 16) / 255.0;
        double g = Convert.ToInt32(hex.Substring(3, 2), 16) / 255.0;
        double b = Convert.ToInt32(hex.Substring(5, 2), 16) / 255.0;
        double max = Math.Max(r, Math.Max(g, b));
        double min = Math.Min(r, Math.Min(g, b));
        double chroma = max - min;
        if (max == 0 || chroma / max < 0.35) { return false; }
        double hue;
        if (max == r) { hue = 60 * (((g - b) / chroma) % 6); }
        else if (max == g) { hue = 60 * (((b - r) / chroma) + 2); }
        else { hue = 60 * (((r - g) / chroma) + 4); }
        if (hue < 0) { hue += 360; }
        return hue < 20 || hue > 340;
    }

    private string[] List(IDictionary entry, string key, List<string> errors)
    {
        List<string> items = new List<string>();
        object value = entry.Contains(key) ? entry[key] : null;
        if (value is string) { items.Add((string)value); }
        else if (value is IEnumerable && !(value is IDictionary))
        {
            foreach (object item in (IEnumerable)value)
            {
                if (item is string && ((string)item).Length > 0) { items.Add((string)item); }
                else { errors.Add(string.Format("icon '{0}': '{1}' entry '{2}' is not a non-empty string", name, key, item)); }
            }
        }
        else if (value != null) { errors.Add(string.Format("icon '{0}': '{1}' must be a list", name, key)); }
        return items.ToArray();
    }
}
