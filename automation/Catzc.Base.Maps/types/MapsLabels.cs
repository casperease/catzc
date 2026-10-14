// The world-map labels (the `labels` section of configs/maps.yml): the fixed text the two PDFs print beside the data,
// namely the title of each view and the header of each axis. The properties mirror the YAML keys, so they are snake_case
// ([ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)). The defaults are declared
// here, once ([ADR-AUTO-DEFAULT#6](/docs/adr/automation/sensible-defaults.md#rule-adr-auto-default6)). MapsConfig
// validates the section (every label one non-empty line of WinAnsi text, each axis header within its limit) and builds
// one.

namespace Catzc.Base.Maps;

public sealed class MapsLabels
{
    public const string DefaultGridTitle = "World map: tracks × file languages";
    public const string DefaultTreeTitle = "World map: repository tree";
    public const string DefaultRowAxis = "Track";
    public const string DefaultColumnAxis = "File language";

    // The title of the grid view (world-map.grid.pdf). Default: DefaultGridTitle.
    public string grid_title { get; }

    // The title of the tree view (world-map.tree.pdf). Default: DefaultTreeTitle.
    public string tree_title { get; }

    // The header of the row axis (the tracks). Default: DefaultRowAxis.
    public string row_axis { get; }

    // The header of the column axis (the file languages). Default: DefaultColumnAxis.
    public string column_axis { get; }

    public MapsLabels(string gridTitle, string treeTitle, string rowAxis, string columnAxis)
    {
        grid_title = gridTitle;
        tree_title = treeTitle;
        row_axis = rowAxis;
        column_axis = columnAxis;
    }
}
