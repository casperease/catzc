// The readers of the maps file's axis and places minimaps, each checked key by key with the defaults filled in.

using System;
using System.Collections;
using System.Collections.Generic;
using System.Globalization;
using static Catzc.Base.Maps.MapsConfig;

namespace Catzc.Base.Maps;

public static class MapsMinimapReaders
{
    private static readonly string[] PlacesKeys = { "rows", "counter_rows", "row_chars", "drop_prefix", "fold_separator", "fold_count_prefix", "row_join", "name_join", "root_marker" };
    private static readonly string[] AxisKeys = { "rows", "columns" };

    // The axis minimap's rows (row name: the value-chain stacks it gathers) and columns (the concerns across).
    internal static MapsMinimapAxis ReadAxis(IDictionary minimaps, List<string> errors)
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

    // The place rows' budget: the defaults, each overridable by minimaps.places.<key>.
    internal static MapsMinimapPlaces ReadPlaces(IDictionary minimaps, List<string> errors)
    {
        MapsMinimapPlaces fallback = MapsMinimapPlaces.Default();
        if (!Has(minimaps, "places")) { return fallback; }
        IDictionary map = minimaps["places"] as IDictionary;
        if (map == null)
        {
            errors.Add("minimaps.places must be a mapping { " + string.Join(", ", PlacesKeys) + " }");
            return fallback;
        }
        CheckKeys("minimaps.places: ", map, PlacesKeys, errors);
        try
        {
            return new MapsMinimapPlaces(
                ReadWhole(map, "rows", fallback.rows, errors),
                ReadWhole(map, "counter_rows", fallback.counter_rows, errors),
                ReadWhole(map, "row_chars", fallback.row_chars, errors),
                Has(map, "drop_prefix") ? Text(map["drop_prefix"]) : fallback.drop_prefix,
                Has(map, "fold_separator") ? Text(map["fold_separator"]) : fallback.fold_separator,
                Has(map, "fold_count_prefix") ? Text(map["fold_count_prefix"]) : fallback.fold_count_prefix,
                Has(map, "row_join") ? Text(map["row_join"]) : fallback.row_join,
                Has(map, "name_join") ? Text(map["name_join"]) : fallback.name_join,
                Has(map, "root_marker") ? Text(map["root_marker"]) : fallback.root_marker);
        }
        catch (ArgumentException error)
        {
            errors.Add("minimaps.places: " + error.Message);
            return fallback;
        }
    }

    private static int ReadWhole(IDictionary map, string key, int fallback, List<string> errors)
    {
        if (!Has(map, key)) { return fallback; }
        int value;
        if (!int.TryParse(Text(map[key]), NumberStyles.Integer, CultureInfo.InvariantCulture, out value))
        {
            errors.Add(string.Format(CultureInfo.InvariantCulture, "minimaps.places.{0} must be a whole number, not '{1}'", key, Text(map[key])));
            return fallback;
        }
        return value;
    }
}
