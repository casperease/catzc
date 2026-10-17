/*
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.Slides/types/SlidesKit.cs
    folder: types
    name: slides-kit
    filetype: cs
    kind: type
    language: csharp
    track: automation
    tracktype: modules
    module: Catzc.Base.Slides
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    test: automation/Catzc.Base.Slides/tests/types/SlidesKit.Tests.ps1
---
*/

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

    public IReadOnlyDictionary<string, string> token { get; }
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
                if (Array.IndexOf(Sections, name) < 0)
                {
                    errors.Add(string.Format(CultureInfo.InvariantCulture, "unknown section '{0}' (allowed: {1})", name, string.Join(", ", Sections)));
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

        foreach (KeyValuePair<string, string> colour in sections["token"])
        {
            if (!HexColour.IsMatch(colour.Value))
            {
                errors.Add(string.Format(CultureInfo.InvariantCulture, "token.{0} '{1}' must be a six-digit hex colour", colour.Key, colour.Value));
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
