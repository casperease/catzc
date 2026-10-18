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

    public const string DefaultKit = ".claude/slides";
    public const string DefaultDrawioKit = ".claude/drawio";
    public const int DefaultDiagramBatch = 25;
    public static readonly string[] DefaultDiagramFolders = { "docs/explanation/.assets" };
    public const string KitDefaultsFile = "slides.yml";
    public const string PatternsFolder = "patterns";
    public const string SlideSuffix = ".slide.md";
    public const string DeckFile = "deck.md";

    private static readonly string[] AllowedKeys = { "kit", "drawio_kit", "diagram_batch", "diagram_folders" };

    public string kit { get; }

    // The draw.io kit whose renderer rebuilds every diagram from its embedded model and the repository's maps.
    public string drawio_kit { get; }

    // How many slides one renderer call takes in the per-slide stages, so each call stays inside its time limit.
    public int diagram_batch { get; }

    // The folders whose slides carry the minimap sidebar the renderer rebuilds; a slide elsewhere keeps the picture it has.
    public IReadOnlyList<string> diagram_folders { get; }

    public SlidesConfig(IDictionary raw)
    {
        List<string> errors = new List<string>();
        string kitValue = DefaultKit;
        string drawioValue = DefaultDrawioKit;
        int batchValue = DefaultDiagramBatch;
        List<string> foldersValue = new List<string>(DefaultDiagramFolders);

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

            if (raw.Contains("diagram_batch") && raw["diagram_batch"] != null)
            {
                if (!int.TryParse(Convert.ToString(raw["diagram_batch"], CultureInfo.InvariantCulture), NumberStyles.Integer, CultureInfo.InvariantCulture, out int batch) || batch < 1)
                {
                    errors.Add(string.Format(CultureInfo.InvariantCulture, "diagram_batch '{0}' must be a whole number of slides, at least 1", raw["diagram_batch"]));
                }
                else
                {
                    batchValue = batch;
                }
            }

            if (raw.Contains("diagram_folders") && raw["diagram_folders"] != null)
            {
                if (!(raw["diagram_folders"] is IEnumerable items) || raw["diagram_folders"] is string)
                {
                    errors.Add("diagram_folders must be a list of repository-relative folders");
                }
                else
                {
                    foldersValue = new List<string>();
                    int index = 0;
                    foreach (object item in items)
                    {
                        var one = new Hashtable { { "folder", item } };
                        string folder = Folder(one, "folder", null, errors);
                        if (folder != null) { foldersValue.Add(folder); }
                        index++;
                    }
                    if (index == 0) { errors.Add("diagram_folders names no folder; leave the key out to take the default"); }
                }
            }
        }

        if (errors.Count > 0)
        {
            throw new ArgumentException("slides.yml: " + string.Join("; ", errors));
        }

        kit = kitValue;
        drawio_kit = drawioValue;
        diagram_batch = batchValue;
        diagram_folders = foldersValue;
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
