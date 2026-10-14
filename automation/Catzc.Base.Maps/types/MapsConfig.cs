// The world-map settings (configs/maps.yml): the palette, the limits, the printed labels, the reviewed highlight pins
// and exceptions, and the output folder the PDFs land in under Get-OutputRoot
// ([ADR-REPO-OUTDIR#2](/docs/adr/repository/dedicated-output-directory.md#rule-adr-repo-outdir2)). Registered in
// Catzc.Base.Config/configs/configs.yml (type: Catzc.Base.Maps.MapsConfig), so Get-Config -Config maps returns this
// typed record. Property names mirror the YAML keys (snake_case,
// [ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)).
//
// Every key has a sensible default, declared once on the type that holds it
// ([ADR-AUTO-DEFAULT#6](/docs/adr/automation/sensible-defaults.md#rule-adr-auto-default6)): MapsPalette, MapsLimits,
// MapsLabels, and here the output folder. An empty file means the defaults; a file sets a key only to change it.
//
// Constructing an instance validates the file, collecting every violation into one ArgumentException:
//   - only the known keys, at the top and in each section; an unknown key (a typo) fails at load;
//   - a section is a mapping, and highlight.pins / highlight.exceptions are lists of { adr, track, file_language, reason };
//   - a colour is '#' and six hex digits (e.g. #DCE6F0);
//   - a size is a positive number, and a label length a positive whole number;
//   - a label is one non-empty line of WinAnsi text, the only text the base-14 PDF fonts show (WinAnsi), and a row or
//     column header fits its limit (row_axis and root_files within max_row_label, column_axis and unlisted_files within
//     max_column_label);
//   - output_folder is one path segment;
//   - a pin names an ADR code (optionally #n), a track name, a kebab-case file language and a reason.

using System;
using System.Collections;
using System.Collections.Generic;
using System.Globalization;
using System.Text.RegularExpressions;

namespace Catzc.Base.Maps;

public sealed class MapsConfig : Catzc.Base.Objects.DictionaryRecord
{
    public const string DefaultOutputFolder = "world-map";

    private const string Failed = "maps config validation failed:\n";
    private static readonly string[] AllowedKeys = { "palette", "limits", "labels", "highlight", "output_folder" };
    private static readonly string[] PaletteKeys = { "background", "row", "column", "cell", "shade", "line", "text", "violation", "highlight" };
    private static readonly string[] LimitsKeys = { "page_width", "page_height", "min_font_size", "max_row_label", "max_column_label" };
    private static readonly string[] LabelsKeys =
    {
        "grid_title", "tree_title", "row_axis", "column_axis", "root_files", "unlisted_files", "legend_files", "legend_violation",
        "legend_highlight"
    };
    private static readonly string[] HighlightKeys = { "pins", "exceptions" };
    private static readonly string[] PinKeys = { "adr", "track", "file_language", "reason" };
    private static readonly Regex Colour = new Regex("^#[0-9A-Fa-f]{6}$");
    private static readonly Regex AdrCode = new Regex("^ADR(-[A-Z0-9]+)+(#[1-9][0-9]*)?$");
    private static readonly Regex TrackName = new Regex("^\\.?[a-z][a-z0-9]*(-[a-z0-9]+)*$");
    private static readonly Regex LanguageName = new Regex("^[a-z][a-z0-9]*(-[a-z0-9]+)*$");

    // The fill colours. Defaults: MapsPalette.
    public MapsPalette palette { get; }

    // The page size, the smallest font size and the longest header names. Defaults: MapsLimits.
    public MapsLimits limits { get; }

    // The titles and axis headers the PDFs print. Defaults: MapsLabels.
    public MapsLabels labels { get; }

    // The reviewed highlight pins and exceptions. Default: none.
    public MapsHighlight highlight { get; }

    // The folder under the output root the world-map PDFs are written to. Default: DefaultOutputFolder.
    public string output_folder { get; }

    public MapsConfig(IDictionary raw)
    {
        List<string> errors = new List<string>();
        CheckKeys("", raw, AllowedKeys, errors);

        IDictionary paletteMap = Section(raw, "palette", PaletteKeys, errors);
        palette = new MapsPalette(
            ReadColour(paletteMap, "background", MapsPalette.DefaultBackground, errors),
            ReadColour(paletteMap, "row", MapsPalette.DefaultRow, errors),
            ReadColour(paletteMap, "column", MapsPalette.DefaultColumn, errors),
            ReadColour(paletteMap, "cell", MapsPalette.DefaultCell, errors),
            ReadColour(paletteMap, "shade", MapsPalette.DefaultShade, errors),
            ReadColour(paletteMap, "line", MapsPalette.DefaultLine, errors),
            ReadColour(paletteMap, "text", MapsPalette.DefaultText, errors),
            ReadColour(paletteMap, "violation", MapsPalette.DefaultViolation, errors),
            ReadColour(paletteMap, "highlight", MapsPalette.DefaultHighlight, errors));

        IDictionary limitsMap = Section(raw, "limits", LimitsKeys, errors);
        limits = new MapsLimits(
            ReadSize(limitsMap, "page_width", MapsLimits.DefaultPageWidth, errors),
            ReadSize(limitsMap, "page_height", MapsLimits.DefaultPageHeight, errors),
            ReadSize(limitsMap, "min_font_size", MapsLimits.DefaultMinFontSize, errors),
            ReadLength(limitsMap, "max_row_label", MapsLimits.DefaultMaxRowLabel, errors),
            ReadLength(limitsMap, "max_column_label", MapsLimits.DefaultMaxColumnLabel, errors));

        IDictionary labelsMap = Section(raw, "labels", LabelsKeys, errors);
        labels = new MapsLabels(
            ReadLabel(labelsMap, "grid_title", MapsLabels.DefaultGridTitle, 0, errors),
            ReadLabel(labelsMap, "tree_title", MapsLabels.DefaultTreeTitle, 0, errors),
            ReadLabel(labelsMap, "row_axis", MapsLabels.DefaultRowAxis, limits.max_row_label, errors),
            ReadLabel(labelsMap, "column_axis", MapsLabels.DefaultColumnAxis, limits.max_column_label, errors),
            ReadLabel(labelsMap, "root_files", MapsLabels.DefaultRootFiles, limits.max_row_label, errors),
            ReadLabel(labelsMap, "unlisted_files", MapsLabels.DefaultUnlistedFiles, limits.max_column_label, errors),
            ReadLabel(labelsMap, "legend_files", MapsLabels.DefaultLegendFiles, 0, errors),
            ReadLabel(labelsMap, "legend_violation", MapsLabels.DefaultLegendViolation, 0, errors),
            ReadLabel(labelsMap, "legend_highlight", MapsLabels.DefaultLegendHighlight, 0, errors));

        IDictionary highlightMap = Section(raw, "highlight", HighlightKeys, errors);
        highlight = new MapsHighlight(ReadPins(highlightMap, "pins", errors), ReadPins(highlightMap, "exceptions", errors));

        output_folder = ReadOutputFolder(raw, errors);

        if (errors.Count > 0) { throw new ArgumentException(Failed + string.Join("\n", errors)); }
    }

    private static string Text(object value) => value == null ? "" : Convert.ToString(value, CultureInfo.InvariantCulture);

    private static bool Has(IDictionary map, string key) => map != null && map.Contains(key) && map[key] != null;

    private static void CheckKeys(string prefix, IDictionary map, string[] allowed, List<string> errors)
    {
        if (map == null) { return; }
        foreach (object k in map.Keys)
        {
            string key = Text(k);
            if (Array.IndexOf(allowed, key) < 0)
            {
                errors.Add(string.Format(CultureInfo.InvariantCulture, "{0}unknown key '{1}' (allowed: {2})", prefix, key, string.Join(", ", allowed)));
            }
        }
    }

    // The named section as a mapping, its keys checked; null (all defaults) when it is omitted or invalid.
    private static IDictionary Section(IDictionary raw, string name, string[] allowed, List<string> errors)
    {
        if (!Has(raw, name)) { return null; }
        IDictionary map = raw[name] as IDictionary;
        if (map == null)
        {
            errors.Add(string.Format(CultureInfo.InvariantCulture, "{0} must be a mapping {{ {1} }}", name, string.Join(", ", allowed)));
            return null;
        }
        CheckKeys(name + ": ", map, allowed, errors);
        return map;
    }

    private static string ReadColour(IDictionary map, string key, string fallback, List<string> errors)
    {
        if (!Has(map, key)) { return fallback; }
        string value = Text(map[key]).Trim();
        if (!Colour.IsMatch(value))
        {
            errors.Add(string.Format(CultureInfo.InvariantCulture, "palette.{0}: invalid colour '{1}' ('#' and six hex digits, e.g. #DCE6F0)", key, value));
            return fallback;
        }
        return value.ToUpperInvariant();
    }

    private static double ReadSize(IDictionary map, string key, double fallback, List<string> errors)
    {
        if (!Has(map, key)) { return fallback; }
        object value = map[key];
        double size = 0;
        bool numeric = !(value is bool) && double.TryParse(Text(value), NumberStyles.Float, CultureInfo.InvariantCulture, out size);
        if (!numeric || double.IsNaN(size) || double.IsInfinity(size) || size <= 0)
        {
            errors.Add(string.Format(CultureInfo.InvariantCulture, "limits.{0}: '{1}' is not a positive number", key, Text(value)));
            return fallback;
        }
        return size;
    }

    private static int ReadLength(IDictionary map, string key, int fallback, List<string> errors)
    {
        if (!Has(map, key)) { return fallback; }
        object value = map[key];
        int length = 0;
        bool whole = !(value is bool) && int.TryParse(Text(value), NumberStyles.Integer, CultureInfo.InvariantCulture, out length);
        if (!whole || length <= 0)
        {
            errors.Add(string.Format(CultureInfo.InvariantCulture, "limits.{0}: '{1}' is not a positive whole number", key, Text(value)));
            return fallback;
        }
        return length;
    }

    // A label: one non-empty line of WinAnsi text, at most maxLength characters when maxLength is positive.
    private static string ReadLabel(IDictionary map, string key, string fallback, int maxLength, List<string> errors)
    {
        string value = Has(map, key) ? Text(map[key]) : fallback;
        if (value.Trim().Length == 0)
        {
            errors.Add(string.Format(CultureInfo.InvariantCulture, "labels.{0} is empty", key));
            return fallback;
        }
        int bad = WinAnsi.IndexOfUnsupported(value);
        if (bad >= 0)
        {
            errors.Add(string.Format(CultureInfo.InvariantCulture,
                "labels.{0}: '{1}' has a character the PDF fonts cannot show: U+{2:X4} at {3} (labels are WinAnsi text: replace it, e.g. '->' for an arrow)",
                key, value, (int)value[bad], bad));
        }
        if (maxLength > 0 && value.Length > maxLength)
        {
            errors.Add(string.Format(CultureInfo.InvariantCulture, "labels.{0}: '{1}' is {2} characters, longer than its limit of {3}", key, value, value.Length, maxLength));
        }
        return value;
    }

    private static MapsPin[] ReadPins(IDictionary map, string key, List<string> errors)
    {
        List<MapsPin> pins = new List<MapsPin>();
        if (!Has(map, key)) { return pins.ToArray(); }
        IList list = map[key] as IList;
        if (list == null || map[key] is string)
        {
            errors.Add(string.Format(CultureInfo.InvariantCulture, "highlight.{0} must be a list of {{ {1} }}", key, string.Join(", ", PinKeys)));
            return pins.ToArray();
        }
        for (int i = 0; i < list.Count; i++)
        {
            string at = string.Format(CultureInfo.InvariantCulture, "highlight.{0}[{1}]", key, i);
            IDictionary entry = list[i] as IDictionary;
            if (entry == null)
            {
                errors.Add(at + string.Format(CultureInfo.InvariantCulture, " must be a mapping {{ {0} }}", string.Join(", ", PinKeys)));
                continue;
            }
            int before = errors.Count;
            CheckKeys(at + ": ", entry, PinKeys, errors);
            string adr = PinField(entry, "adr", AdrCode, "an ADR code, optionally with its rule, e.g. ADR-WIDGET-GADGET#3", at, errors);
            string track = PinField(entry, "track", TrackName, "a track name, e.g. widgets or .gadgets", at, errors);
            string language = PinField(entry, "file_language", LanguageName, "a kebab-case file-language name", at, errors);
            string reason = Has(entry, "reason") ? Text(entry["reason"]).Trim() : "";
            if (reason.Length == 0) { errors.Add(at + ": reason is required (why the entry was reviewed)"); }
            if (errors.Count == before) { pins.Add(new MapsPin(adr, track, language, reason)); }
        }
        return pins.ToArray();
    }

    private static string PinField(IDictionary entry, string key, Regex shape, string hint, string at, List<string> errors)
    {
        string value = Has(entry, key) ? Text(entry[key]).Trim() : "";
        if (value.Length == 0)
        {
            errors.Add(string.Format(CultureInfo.InvariantCulture, "{0}: {1} is required", at, key));
        }
        else if (!shape.IsMatch(value))
        {
            errors.Add(string.Format(CultureInfo.InvariantCulture, "{0}: invalid {1} '{2}' ({3})", at, key, value, hint));
        }
        return value;
    }

    // One path segment under the output root: no separator, no '..', not rooted.
    private static string ReadOutputFolder(IDictionary raw, List<string> errors)
    {
        if (!Has(raw, "output_folder")) { return DefaultOutputFolder; }
        string value = Text(raw["output_folder"]).Trim();
        if (value.Length == 0 || value == "." || value.Contains("/") || value.Contains("\\") || value.Contains("..") || value.Contains(":"))
        {
            errors.Add(string.Format(CultureInfo.InvariantCulture, "output_folder '{0}' must be one folder name under the output root (no '/', '\\', '..', or ':')", value));
            return DefaultOutputFolder;
        }
        return value;
    }
}
