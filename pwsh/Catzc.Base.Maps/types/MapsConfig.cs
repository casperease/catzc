/*
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.Maps/types/MapsConfig.cs
    folder: types
    name: maps-config
    filetype: cs
    role: type
    language: csharp
    track: pwsh
    tracktype: modules
    module: Catzc.Base.Maps
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    test: pwsh/Catzc.Base.Maps/tests/types/MapsConfig.Tests.ps1
    docs: "[MapsConfig.cs.md](docs/references/pwsh/catzc-base-maps/types/MapsConfig.cs.md)"
    cites:
      - ADR-AUTO-DEFAULT-ONERESOLUTIONORDER
      - ADR-BCL-TYPES-SNAKECASEMIRRORSYAML
      - ADR-REPO-OUTDIR-SUBDIRECTORYPERPRODUCER
---
*/

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
    private static readonly string[] AllowedKeys = { "palette", "limits", "labels", "highlight", "output_folder", "minimaps" };
    private static readonly string[] MinimapKinds = { "explanation", "reference" };
    private static readonly string[] MinimapKeys = { "explanation", "reference", "data", "axis" };
    private static readonly string[] AxisKeys = { "rows", "columns" };

    // The command that computes each minimap's data from a diagram's ADR codes (-Adr, -AsJson), by minimap id.
    public static readonly IReadOnlyDictionary<string, string> DefaultMinimapData = new Dictionary<string, string>(StringComparer.Ordinal)
    {
        [MinimapData.Grid] = "Get-GridMinimapData",
        [MinimapData.CodeLocations] = "Get-CodeLocationsMinimapData",
        [MinimapData.Axis] = "Get-AxisMinimapData",
        [MinimapData.LayerStack] = "Get-LayerStackMinimapData",
        [MinimapData.LifecyclePosition] = "Get-LifecyclePositionMinimapData",
        [MinimapData.TrackPlacement] = "Get-TrackPlacementMinimapData",
        [MinimapData.EngineStrip] = "Get-EngineStripMinimapData",
        [MinimapData.ModuleNeighbourhood] = "Get-ModuleNeighbourhoodMinimapData",
    };
    private static readonly string[] PoolKeys = { "pool", "defaults" };
    private static readonly string[] PaletteKeys = { "background", "row", "column", "cell", "shade", "line", "text", "violation", "highlight" };
    private static readonly string[] LimitsKeys = { "page_width", "page_height", "min_font_size", "max_row_label", "max_column_label" };
    private static readonly string[] LabelsKeys =
    {
        "grid_title", "tree_title", "row_axis", "column_axis", "root_files", "unlisted_files", "legend_files", "legend_violation",
        "legend_highlight", "value_chain_title", "value_chain_row_axis", "value_chain_column_axis", "value_chain_legend_adrs",
        "value_chain_legend_highlight"
    };
    private static readonly string[] HighlightKeys = { "pins", "exceptions", "citation_exclude" };
    private static readonly string[] PinKeys = { "adr", "track", "file_language", "reason" };
    private static readonly Regex Colour = new Regex("^#[0-9A-Fa-f]{6}$");
    private static readonly Regex AdrCode = new Regex("^ADR(-[A-Z][A-Z0-9]*)+$");
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

    // The minimaps an explanation diagram may show, and its three defaults. Defaults: MapsMinimapPool.DefaultExplanation*.
    public MapsMinimapPool explanation_minimaps { get; }

    // The minimaps a reference diagram may show, and its three defaults. Defaults: MapsMinimapPool.DefaultReference*.
    public MapsMinimapPool reference_minimaps { get; }

    // The command that computes each minimap's data, by minimap id; every id has one. Defaults: DefaultMinimapData.
    public IReadOnlyDictionary<string, string> minimap_data { get; }

    // The axis minimap's rows and columns. Defaults: MapsMinimapAxis.DefaultRows and DefaultColumns.
    public MapsMinimapAxis minimap_axis { get; }

    // The pool of a diagram kind, explanation or reference.
    public MapsMinimapPool MinimapsOf(string kind)
    {
        if (string.Equals(kind, "explanation", StringComparison.Ordinal)) { return explanation_minimaps; }
        if (string.Equals(kind, "reference", StringComparison.Ordinal)) { return reference_minimaps; }
        throw new ArgumentException("diagram kind '" + kind + "' is not one of: " + string.Join(", ", MinimapKinds), nameof(kind));
    }

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
            ReadLabel(labelsMap, "legend_highlight", MapsLabels.DefaultLegendHighlight, 0, errors),
            ReadLabel(labelsMap, "value_chain_title", MapsLabels.DefaultValueChainTitle, 0, errors),
            ReadLabel(labelsMap, "value_chain_row_axis", MapsLabels.DefaultValueChainRowAxis, 0, errors),
            ReadLabel(labelsMap, "value_chain_column_axis", MapsLabels.DefaultValueChainColumnAxis, 0, errors),
            ReadLabel(labelsMap, "value_chain_legend_adrs", MapsLabels.DefaultValueChainLegendAdrs, 0, errors),
            ReadLabel(labelsMap, "value_chain_legend_highlight", MapsLabels.DefaultValueChainLegendHighlight, 0, errors));

        IDictionary highlightMap = Section(raw, "highlight", HighlightKeys, errors);
        highlight = new MapsHighlight(ReadPins(highlightMap, "pins", errors), ReadPins(highlightMap, "exceptions", errors),
            ReadGlobs(highlightMap, "citation_exclude", MapsHighlight.DefaultCitationExclude, errors));

        output_folder = ReadOutputFolder(raw, errors);

        IDictionary minimapsMap = Section(raw, "minimaps", MinimapKeys, errors);
        explanation_minimaps = ReadPool(minimapsMap, "explanation", MapsMinimapPool.DefaultExplanationPool, MapsMinimapPool.DefaultExplanationDefaults, errors);
        reference_minimaps = ReadPool(minimapsMap, "reference", MapsMinimapPool.DefaultReferencePool, MapsMinimapPool.DefaultReferenceDefaults, errors);
        minimap_data = ReadMinimapData(minimapsMap, errors);
        minimap_axis = ReadAxis(minimapsMap, errors);

        if (errors.Count > 0) { throw new ArgumentException(Failed + string.Join("\n", errors)); }
    }

    private static string Text(object value) => value == null ? "" : Convert.ToString(value, CultureInfo.InvariantCulture);

    // The data command per minimap id: the defaults, each overridable by minimaps.data.<id>; an unknown id fails with the ids.
    private static IReadOnlyDictionary<string, string> ReadMinimapData(IDictionary minimaps, List<string> errors)
    {
        Dictionary<string, string> data = new Dictionary<string, string>(DefaultMinimapData, StringComparer.Ordinal);
        if (!Has(minimaps, "data")) { return data; }
        IDictionary map = minimaps["data"] as IDictionary;
        if (map == null)
        {
            errors.Add("minimaps.data must be a mapping of minimap id: command");
            return data;
        }
        foreach (object key in map.Keys)
        {
            string id = Text(key);
            string command = Text(map[key]);
            if (!MinimapData.Ids.Contains(id))
            {
                errors.Add(string.Format(CultureInfo.InvariantCulture, "minimaps.data: '{0}' is not one of: {1}", id, string.Join(", ", MinimapData.Ids)));
            }
            else if (!Regex.IsMatch(command, "^[A-Z][a-z]+-[A-Za-z]+$"))
            {
                errors.Add(string.Format(CultureInfo.InvariantCulture, "minimaps.data.{0} '{1}' must be a Verb-Noun command name", id, command));
            }
            else
            {
                data[id] = command;
            }
        }
        return data;
    }

    // The axis minimap's rows (row name: the value-chain stacks it gathers) and columns (the concerns across).
    private static MapsMinimapAxis ReadAxis(IDictionary minimaps, List<string> errors)
    {
        IReadOnlyList<KeyValuePair<string, IReadOnlyList<string>>> rows = MapsMinimapAxis.DefaultRows;
        IReadOnlyList<string> columns = MapsMinimapAxis.DefaultColumns;
        if (!Has(minimaps, "axis")) { return new MapsMinimapAxis(rows, columns); }
        IDictionary map = minimaps["axis"] as IDictionary;
        if (map == null)
        {
            errors.Add("minimaps.axis must be a mapping { rows, columns }");
            return new MapsMinimapAxis(rows, columns);
        }
        CheckKeys("minimaps.axis: ", map, AxisKeys, errors);
        if (Has(map, "rows"))
        {
            IDictionary listed = map["rows"] as IDictionary;
            if (listed == null) { errors.Add("minimaps.axis.rows must be a mapping of row: [value-chain stacks]"); }
            else
            {
                List<KeyValuePair<string, IReadOnlyList<string>>> read = new List<KeyValuePair<string, IReadOnlyList<string>>>();
                foreach (object key in listed.Keys)
                {
                    List<string> stacks = new List<string>();
                    foreach (object stack in (listed[key] as IList) ?? Array.Empty<object>()) { stacks.Add(Text(stack)); }
                    if (stacks.Count == 0) { errors.Add(string.Format(CultureInfo.InvariantCulture, "minimaps.axis.rows.{0} names no value-chain stack", Text(key))); }
                    read.Add(new KeyValuePair<string, IReadOnlyList<string>>(Text(key), stacks.AsReadOnly()));
                }
                rows = read.AsReadOnly();
            }
        }
        if (Has(map, "columns"))
        {
            IList listed = map["columns"] as IList;
            if (listed == null) { errors.Add("minimaps.axis.columns must be a list of concerns"); }
            else
            {
                List<string> read = new List<string>();
                foreach (object item in listed) { read.Add(Text(item)); }
                columns = read.AsReadOnly();
            }
        }
        return new MapsMinimapAxis(rows, columns);
    }

    // One kind's pool and defaults: every id one of the eight minimaps, exactly three defaults, each in the pool.
    private static MapsMinimapPool ReadPool(IDictionary minimaps, string kind, IReadOnlyList<string> poolFallback, IReadOnlyList<string> defaultsFallback,
        List<string> errors)
    {
        IDictionary map = null;
        if (Has(minimaps, kind))
        {
            map = minimaps[kind] as IDictionary;
            if (map == null) { errors.Add(string.Format(CultureInfo.InvariantCulture, "minimaps.{0} must be a mapping {{ pool, defaults }}", kind)); }
            CheckKeys("minimaps." + kind + ": ", map, PoolKeys, errors);
        }
        IReadOnlyList<string> pool = ReadIds(map, kind, "pool", poolFallback, errors);
        IReadOnlyList<string> defaults = ReadIds(map, kind, "defaults", defaultsFallback, errors);
        if (defaults.Count != MapsMinimapPool.Shown)
        {
            errors.Add(string.Format(CultureInfo.InvariantCulture, "minimaps.{0}.defaults names {1} minimaps; a diagram shows exactly {2}", kind, defaults.Count, MapsMinimapPool.Shown));
        }
        foreach (string id in defaults)
        {
            if (!Contains(pool, id))
            {
                errors.Add(string.Format(CultureInfo.InvariantCulture, "minimaps.{0}.defaults: '{1}' is not in the pool ({2})", kind, id, string.Join(", ", pool)));
            }
        }
        return new MapsMinimapPool(pool, defaults);
    }

    private static IReadOnlyList<string> ReadIds(IDictionary map, string kind, string key, IReadOnlyList<string> fallback, List<string> errors)
    {
        if (!Has(map, key)) { return fallback; }
        IList listed = map[key] as IList;
        if (listed == null)
        {
            errors.Add(string.Format(CultureInfo.InvariantCulture, "minimaps.{0}.{1} must be a list of minimap ids", kind, key));
            return fallback;
        }
        List<string> ids = new List<string>();
        foreach (object item in listed)
        {
            string id = Text(item);
            if (!MinimapData.Ids.Contains(id))
            {
                errors.Add(string.Format(CultureInfo.InvariantCulture, "minimaps.{0}.{1}: '{2}' is not one of: {3}", kind, key, id, string.Join(", ", MinimapData.Ids)));
                continue;
            }
            ids.Add(id);
        }
        return ids.AsReadOnly();
    }

    private static bool Contains(IReadOnlyList<string> items, string item)
    {
        foreach (string candidate in items)
        {
            if (string.Equals(candidate, item, StringComparison.Ordinal)) { return true; }
        }
        return false;
    }

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
            string adr = PinField(entry, "adr", AdrCode, "an ADR or rule code, e.g. ADR-WIDGET-GADGET or ADR-WIDGET-GADGET-SPROCKET", at, errors);
            string track = PinField(entry, "track", TrackName, "a track name, e.g. widgets or .gadgets", at, errors);
            string language = PinField(entry, "file_language", LanguageName, "a kebab-case file-language name", at, errors);
            string reason = Has(entry, "reason") ? Text(entry["reason"]).Trim() : "";
            if (reason.Length == 0) { errors.Add(at + ": reason is required (why the entry was reviewed)"); }
            if (errors.Count == before) { pins.Add(new MapsPin(adr, track, language, reason)); }
        }
        return pins.ToArray();
    }

    // A list of repository-relative glob strings, each non-empty, '/'-separated and not rooted; the default when absent.
    private static string[] ReadGlobs(IDictionary map, string key, IReadOnlyList<string> fallback, List<string> errors)
    {
        if (!Has(map, key)) { return new List<string>(fallback).ToArray(); }
        IList list = map[key] as IList;
        if (list == null || map[key] is string)
        {
            errors.Add(string.Format(CultureInfo.InvariantCulture, "highlight.{0} must be a list of globs, e.g. [docs/.assets/**]", key));
            return Array.Empty<string>();
        }
        List<string> globs = new List<string>();
        for (int i = 0; i < list.Count; i++)
        {
            string glob = Text(list[i]).Trim();
            if (glob.Length == 0 || glob.Contains("\\") || glob.StartsWith("/", StringComparison.Ordinal))
            {
                errors.Add(string.Format(CultureInfo.InvariantCulture,
                    "highlight.{0}[{1}]: '{2}' is not a repository-relative glob ('/'-separated, not rooted)", key, i, glob));
                continue;
            }
            globs.Add(glob);
        }
        return globs.ToArray();
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
