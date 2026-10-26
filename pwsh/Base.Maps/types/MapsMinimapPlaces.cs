using System;
using System.Collections.Generic;

namespace Catzc.Base.Maps;

// The budget of the "Where does it live?" minimap and the order its place groups take the rows.
[Catzc.Base.Objects.ConsoleDisplay(nameof(rows), nameof(counter_rows), nameof(row_chars))]
public sealed class MapsMinimapPlaces
{
    public const int DefaultRows = 7;
    public const int DefaultCounterRows = 1;
    public const int DefaultRowChars = 40;
    public const string DefaultDropPrefix = "Catzc.";
    public const string DefaultFoldSeparator = "|";
    public const string DefaultFoldCountPrefix = "+";
    public const string DefaultRowJoin = ".";
    public const string DefaultNameJoin = "_";
    public const string DefaultRootMarker = "(root)";

    // The rows the places share. Default: DefaultRows.
    public int rows { get; }

    // The rows under the places for the counters line, zero or one. Default: DefaultCounterRows.
    public int counter_rows { get; }

    // The most characters a row holds. Default: DefaultRowChars.
    public int row_chars { get; }

    // The module prefix a row drops, whole. Default: DefaultDropPrefix.
    public string drop_prefix { get; }

    // What joins the names of the sub-folders a folded row holds. Default: DefaultFoldSeparator.
    public string fold_separator { get; }

    // What opens the count a folded row falls back to when not even one name fits. Default: DefaultFoldCountPrefix.
    public string fold_count_prefix { get; }

    // What joins the parts of a row, the path from the repository root. Default: DefaultRowJoin.
    public string row_join { get; }

    // What joins the dots of a module's name once the prefix is dropped (Azure.Templates is azure_templates). Default: DefaultNameJoin.
    public string name_join { get; }

    // What a module's own root is called among its joined sub-folders. Default: DefaultRootMarker.
    public string root_marker { get; }

    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    public MapsMinimapPlaces(int rows, int counterRows, int rowChars, string dropPrefix,
        string foldSeparator = DefaultFoldSeparator, string foldCountPrefix = DefaultFoldCountPrefix, string rowJoin = DefaultRowJoin,
        string nameJoin = DefaultNameJoin, string rootMarker = DefaultRootMarker)
    {
        List<string> errors = new List<string>();
        if (rows < 1) { errors.Add("rows must be at least 1"); }
        if (counterRows < 0 || counterRows > 1) { errors.Add("counter_rows must be 0 or 1"); }
        if (rowChars < 10) { errors.Add("row_chars must be at least 10"); }
        if (string.IsNullOrEmpty(foldSeparator)) { errors.Add("fold_separator must not be empty"); }
        if (string.IsNullOrEmpty(foldCountPrefix)) { errors.Add("fold_count_prefix must not be empty"); }
        if (string.IsNullOrEmpty(rowJoin)) { errors.Add("row_join must not be empty"); }
        if (string.IsNullOrEmpty(nameJoin)) { errors.Add("name_join must not be empty"); }
        if (string.IsNullOrEmpty(rootMarker)) { errors.Add("root_marker must not be empty"); }
        if (errors.Count > 0) { throw new ArgumentException("minimap places: " + string.Join("; ", errors)); }
        this.rows = rows;
        counter_rows = counterRows;
        row_chars = rowChars;
        drop_prefix = dropPrefix ?? "";
        fold_separator = foldSeparator;
        fold_count_prefix = foldCountPrefix;
        row_join = rowJoin;
        name_join = nameJoin;
        root_marker = rootMarker;
    }

    public static MapsMinimapPlaces Default() =>
        new MapsMinimapPlaces(DefaultRows, DefaultCounterRows, DefaultRowChars, DefaultDropPrefix);
}
