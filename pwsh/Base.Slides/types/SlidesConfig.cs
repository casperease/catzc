/*
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-slides/types/SlidesConfig.cs.md"
  header: "generated"
---
*/

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

    public const string DefaultKit = "python/diagrams/assets/slides";
    public const string DefaultDrawioKit = "python/diagrams";
    public const string KitDefaultsFile = "slides.yml";
    public const string PatternsFolder = "patterns";
    public const string SlideSuffix = ".slide.md";
    public const string DeckFile = "deck.md";
    public const string DefaultTheme = "dark";
    public const int DefaultRenderParallel = 3;

    private static readonly string[] AllowedKeys = { "kit", "drawio_kit", "theme", "render_parallel", "name_mentions" };

    public string kit { get; }

    // The draw.io kit whose renderer rebuilds every diagram from its embedded model and the repository's maps.
    public string drawio_kit { get; }

    // The theme a build renders in when it names none: the one whose diagram rasters are committed. Each kit declares its themes.
    public string theme { get; }

    // The worker processes a diagram build splits its renders across, each with a disjoint slice of the diagrams.
    public int render_parallel { get; }

    public IReadOnlyDictionary<string, string> name_mentions { get; }

    public SlidesConfig(IDictionary raw)
    {
        List<string> errors = new List<string>();
        string kitValue = DefaultKit;
        string drawioValue = DefaultDrawioKit;
        string themeValue = DefaultTheme;
        int parallelValue = DefaultRenderParallel;
        Dictionary<string, string> mentions = new Dictionary<string, string>(StringComparer.Ordinal);

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
            if (raw.Contains("theme") && raw["theme"] != null)
            {
                string value = raw["theme"] as string;
                if (string.IsNullOrEmpty(value) || !System.Text.RegularExpressions.Regex.IsMatch(value, "^[a-z][a-z0-9-]*$"))
                {
                    errors.Add(string.Format(CultureInfo.InvariantCulture, "theme '{0}' must be a theme name: lowercase letters, digits and '-'", value));
                }
                else
                {
                    themeValue = value;
                }
            }
            if (raw.Contains("render_parallel") && raw["render_parallel"] != null)
            {
                if (!int.TryParse(Convert.ToString(raw["render_parallel"], CultureInfo.InvariantCulture), NumberStyles.None, CultureInfo.InvariantCulture, out int parsed) || parsed < 1)
                {
                    errors.Add(string.Format(CultureInfo.InvariantCulture, "render_parallel '{0}' must be a whole number of workers, 1 or more", raw["render_parallel"]));
                }
                else
                {
                    parallelValue = parsed;
                }
            }
            if (raw.Contains("name_mentions") && raw["name_mentions"] != null)
            {
                if (!(raw["name_mentions"] is IDictionary declared))
                {
                    errors.Add("name_mentions must map a diagram stem or a slide path to the reason its mention is a contrast");
                }
                else
                {
                    foreach (object key in declared.Keys)
                    {
                        string path = Convert.ToString(key, CultureInfo.InvariantCulture);
                        string reason = Convert.ToString(declared[key], CultureInfo.InvariantCulture);
                        if (string.IsNullOrWhiteSpace(path) || path.Contains('\\') || path.StartsWith("/", StringComparison.Ordinal) || path.Contains(".."))
                        {
                            errors.Add(string.Format(CultureInfo.InvariantCulture, "name_mentions key '{0}' must be a repository-relative path in communication form", path));
                        }
                        else if (string.IsNullOrWhiteSpace(reason))
                        {
                            errors.Add(string.Format(CultureInfo.InvariantCulture, "name_mentions['{0}'] must say why its mention is a contrast", path));
                        }
                        else
                        {
                            mentions[path] = reason.Trim();
                        }
                    }
                }
            }
        }

        if (errors.Count > 0)
        {
            throw new ArgumentException("slides.yml: " + string.Join("; ", errors));
        }

        kit = kitValue;
        drawio_kit = drawioValue;
        theme = themeValue;
        render_parallel = parallelValue;
        name_mentions = mentions;
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
