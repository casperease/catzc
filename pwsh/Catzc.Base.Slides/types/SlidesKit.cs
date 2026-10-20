using System;
using System.Collections;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Text.RegularExpressions;

namespace Catzc.Base.Slides;

public sealed class SlidesKit
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    public const string DefaultOut = "out/slides";

    private static readonly string[] Sections = { "token", "face", "scale", "layout", "render" };
    private static readonly string[] RequiredFaces = { "display", "text" };
    private static readonly Regex HexColour = new Regex("^#[0-9A-Fa-f]{6}$", RegexOptions.Compiled);
    private static readonly Regex QuotedFamily = new Regex("^\\s*'([^']+)'", RegexOptions.Compiled);
    // A theme's token set: `token-<theme>`, beside `token`, the set of the default theme (SlidesConfig.DefaultTheme).
    private static readonly Regex ThemeSection = new Regex("^token-([a-z][a-z0-9-]*)$", RegexOptions.Compiled);

    public IReadOnlyDictionary<string, string> token { get; private set; }

    // Every theme's token set by theme name, the default theme's included; each names the same tokens.
    public IReadOnlyDictionary<string, IReadOnlyDictionary<string, string>> themes { get; }
    public IReadOnlyDictionary<string, string> face { get; }
    public IReadOnlyDictionary<string, string> scale { get; }
    public IReadOnlyDictionary<string, string> layout { get; }
    public IReadOnlyDictionary<string, string> render { get; }

    public SlidesKit(IDictionary raw)
    {
        List<string> errors = new List<string>();
        Dictionary<string, Dictionary<string, string>> sections = new Dictionary<string, Dictionary<string, string>>(StringComparer.Ordinal);
        foreach (string section in Sections)
        {
            sections[section] = new Dictionary<string, string>(StringComparer.Ordinal);
        }

        if (raw != null)
        {
            foreach (object key in raw.Keys)
            {
                string name = Convert.ToString(key, CultureInfo.InvariantCulture);
                if (ThemeSection.IsMatch(name) && !sections.ContainsKey(name))
                {
                    sections[name] = new Dictionary<string, string>(StringComparer.Ordinal);
                }
                else if (Array.IndexOf(Sections, name) < 0)
                {
                    errors.Add(string.Format(CultureInfo.InvariantCulture, "unknown section '{0}' (allowed: {1}, token-<theme>)", name, string.Join(", ", Sections)));
                    continue;
                }

                IDictionary values = raw[key] as IDictionary;
                if (values == null)
                {
                    errors.Add(string.Format(CultureInfo.InvariantCulture, "section '{0}' must be a mapping of key: value", name));
                    continue;
                }

                foreach (object entry in values.Keys)
                {
                    string entryName = Convert.ToString(entry, CultureInfo.InvariantCulture);
                    object value = values[entry];
                    if (value == null || value is IDictionary || (value is IList && !(value is string)))
                    {
                        errors.Add(string.Format(CultureInfo.InvariantCulture, "{0}.{1} must be one scalar value", name, entryName));
                        continue;
                    }

                    sections[name][entryName] = Convert.ToString(value, CultureInfo.InvariantCulture);
                }
            }
        }

        Dictionary<string, IReadOnlyDictionary<string, string>> sets = new Dictionary<string, IReadOnlyDictionary<string, string>>(StringComparer.Ordinal);
        sets[SlidesConfig.DefaultTheme] = sections["token"];
        foreach (string section in sections.Keys.Where(s => ThemeSection.IsMatch(s)).OrderBy(s => s, StringComparer.Ordinal))
        {
            string theme = ThemeSection.Match(section).Groups[1].Value;
            if (theme == SlidesConfig.DefaultTheme)
            {
                errors.Add(string.Format(CultureInfo.InvariantCulture, "{0} repeats the default theme, whose set is token", section));
                continue;
            }

            string[] missing = sections["token"].Keys.Except(sections[section].Keys).OrderBy(k => k, StringComparer.Ordinal).ToArray();
            string[] extra = sections[section].Keys.Except(sections["token"].Keys).OrderBy(k => k, StringComparer.Ordinal).ToArray();
            if (missing.Length > 0 || extra.Length > 0)
            {
                errors.Add(string.Format(CultureInfo.InvariantCulture, "{0} names the tokens of token: missing {1}; unknown {2}", section, missing.Length > 0 ? string.Join(", ", missing) : "none", extra.Length > 0 ? string.Join(", ", extra) : "none"));
            }

            sets[theme] = sections[section];
        }

        foreach (KeyValuePair<string, Dictionary<string, string>> set in sections.Where(s => s.Key == "token" || ThemeSection.IsMatch(s.Key)))
        {
            foreach (KeyValuePair<string, string> colour in set.Value)
            {
                if (!HexColour.IsMatch(colour.Value))
                {
                    errors.Add(string.Format(CultureInfo.InvariantCulture, "{0}.{1} '{2}' must be a six-digit hex colour", set.Key, colour.Key, colour.Value));
                }
            }
        }

        foreach (string section in new[] { "scale", "layout" })
        {
            foreach (KeyValuePair<string, string> number in sections[section])
            {
                long parsed;
                if (!long.TryParse(number.Value, NumberStyles.None, CultureInfo.InvariantCulture, out parsed) || parsed < 1)
                {
                    errors.Add(string.Format(CultureInfo.InvariantCulture, "{0}.{1} '{2}' must be a whole number of pixels", section, number.Key, number.Value));
                }
            }
        }

        foreach (string required in RequiredFaces)
        {
            if (!sections["face"].ContainsKey(required))
            {
                errors.Add(string.Format(CultureInfo.InvariantCulture, "face.{0} is required: the font stack of the {0} face", required));
            }
        }

        if (!sections["render"].ContainsKey("out"))
        {
            sections["render"]["out"] = DefaultOut;
        }

        if (errors.Count > 0)
        {
            throw new ArgumentException("the slides kit's slides.yml: " + string.Join("; ", errors));
        }

        token = sections["token"];
        themes = sets;
        face = sections["face"];
        scale = sections["scale"];
        layout = sections["layout"];
        render = sections["render"];
    }

    public string Value(string reference)
    {
        if (string.IsNullOrEmpty(reference))
        {
            throw new ArgumentException("a kit reference is '<section>.<key>'", nameof(reference));
        }

        int dot = reference.IndexOf('.');
        if (dot <= 0 || dot == reference.Length - 1)
        {
            throw new KeyNotFoundException(string.Format(CultureInfo.InvariantCulture, "the kit declares no value '{0}': a reference is '<section>.<key>'", reference));
        }

        string section = reference.Substring(0, dot);
        string key = reference.Substring(dot + 1);
        IReadOnlyDictionary<string, string> values = SectionOf(section);
        string value;
        if (values == null || !values.TryGetValue(key, out value))
        {
            throw new KeyNotFoundException(string.Format(CultureInfo.InvariantCulture, "the kit declares no value '{0}'", reference));
        }

        return value;
    }

    // The kit with a theme's token set as its tokens; a theme the kit does not declare fails, naming the themes it does.
    public SlidesKit ForTheme(string theme)
    {
        IReadOnlyDictionary<string, string> set;
        if (string.IsNullOrEmpty(theme) || !themes.TryGetValue(theme, out set))
        {
            throw new KeyNotFoundException(string.Format(CultureInfo.InvariantCulture, "the slides kit declares no theme '{0}' (themes: {1})", theme, string.Join(", ", themes.Keys)));
        }

        SlidesKit themed = (SlidesKit)MemberwiseClone();
        themed.token = set;
        return themed;
    }

    public IReadOnlyList<KeyValuePair<string, string>> Families()
    {
        List<KeyValuePair<string, string>> families = new List<KeyValuePair<string, string>>();
        foreach (KeyValuePair<string, string> entry in face.Where(f => !f.Key.EndsWith("_href", StringComparison.Ordinal)).OrderBy(f => f.Key, StringComparer.Ordinal))
        {
            string href;
            face.TryGetValue(entry.Key + "_href", out href);
            families.Add(new KeyValuePair<string, string>(FamilyOf(entry.Value), href));
        }

        return families;
    }

    public static string FamilyOf(string stack)
    {
        if (string.IsNullOrWhiteSpace(stack))
        {
            return string.Empty;
        }

        Match quoted = QuotedFamily.Match(stack);
        if (quoted.Success)
        {
            return quoted.Groups[1].Value;
        }

        return stack.Split(',')[0].Trim();
    }

    private IReadOnlyDictionary<string, string> SectionOf(string section)
    {
        switch (section)
        {
            case "token": return token;
            case "face": return face;
            case "scale": return scale;
            case "layout": return layout;
            case "render": return render;
            default: return null;
        }
    }
}
