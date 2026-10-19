using System;
using System.Collections;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Linq;

namespace Catzc.Base.Slides;

public sealed class SlidesConfig
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    public const string DefaultKit = "python/Catzc.Diagrams/assets/slides";
    public const string DefaultDrawioKit = "python/Catzc.Diagrams";
    public const string KitDefaultsFile = "slides.yml";
    public const string PatternsFolder = "patterns";
    public const string SlideSuffix = ".slide.md";
    public const string DeckFile = "deck.md";

    private static readonly string[] AllowedKeys = { "kit", "drawio_kit" };

    public string kit { get; }

    // The draw.io kit whose renderer rebuilds every diagram from its embedded model and the repository's maps.
    public string drawio_kit { get; }

    public SlidesConfig(IDictionary raw)
    {
        List<string> errors = new List<string>();
        string kitValue = DefaultKit;
        string drawioValue = DefaultDrawioKit;

        if (raw != null)
        {
            foreach (object key in raw.Keys)
            {
                string name = Convert.ToString(key, CultureInfo.InvariantCulture);
                if (Array.IndexOf(AllowedKeys, name) < 0)
                {
                    errors.Add(string.Format(CultureInfo.InvariantCulture, "unknown key '{0}' (allowed: {1})", name, string.Join(", ", AllowedKeys)));
                }
            }

            kitValue = Folder(raw, "kit", kitValue, errors);
            drawioValue = Folder(raw, "drawio_kit", drawioValue, errors);
        }

        if (errors.Count > 0)
        {
            throw new ArgumentException("slides.yml: " + string.Join("; ", errors));
        }

        kit = kitValue;
        drawio_kit = drawioValue;
    }

    static string Folder(IDictionary raw, string key, string fallback, List<string> errors)
    {
        if (!raw.Contains(key) || raw[key] == null) { return fallback; }
        string value = raw[key] as string;
        bool communicationForm = !string.IsNullOrWhiteSpace(value)
            && !Path.IsPathRooted(value)
            && !value.StartsWith("/", StringComparison.Ordinal)
            && value.IndexOf('\\') < 0
            && !value.Split('/').Any(segment => segment == "." || segment == "..");
        if (!communicationForm)
        {
            errors.Add(string.Format(CultureInfo.InvariantCulture, "{0} '{1}' must be a repository-relative folder in communication form: '/'-separated, no '.' or '..' segment, not absolute", key, value));
            return fallback;
        }
        return value.TrimEnd('/');
    }
}
