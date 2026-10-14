// The world-map labels (the `labels` section of configs/maps.yml): the fixed text the two PDFs print beside the data,
// namely the title of each view, the header of each axis, the headers of the two catch-all lines of the grid and the
// legend's entries. The catch-all row holds the root files
// ([ADR-DSGN-TRACK#7](/docs/adr/design/tracks.md#rule-adr-dsgn-track7)) and the catch-all column the unlisted files
// ([ADR-DSGN-TRACK#8](/docs/adr/design/tracks.md#rule-adr-dsgn-track8)), so their headers print those terms. The
// properties mirror the YAML keys, so they are snake_case
// ([ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)). The defaults are declared
// here, once ([ADR-AUTO-DEFAULT#6](/docs/adr/automation/sensible-defaults.md#rule-adr-auto-default6)). MapsConfig
// validates the section (every label one non-empty line of WinAnsi text, each row or column header within its limit)
// and builds one.

namespace Catzc.Base.Maps;

public sealed class MapsLabels
{
    public const string DefaultGridTitle = "World map: tracks × file languages";
    public const string DefaultTreeTitle = "World map: repository tree";
    public const string DefaultRowAxis = "Track";
    public const string DefaultColumnAxis = "File language";
    public const string DefaultRootFiles = "Root files";
    public const string DefaultUnlistedFiles = "Unlisted files";
    public const string DefaultLegendFiles = "Files per cell";
    public const string DefaultLegendViolation = "Stack violation";
    public const string DefaultLegendHighlight = "Lit cell";

    // The title of the grid view (world-map.grid.pdf). Default: DefaultGridTitle.
    public string grid_title { get; }

    // The title of the tree view (world-map.tree.pdf). Default: DefaultTreeTitle.
    public string tree_title { get; }

    // The header of the row axis (the tracks). Default: DefaultRowAxis.
    public string row_axis { get; }

    // The header of the column axis (the file languages). Default: DefaultColumnAxis.
    public string column_axis { get; }

    // The header of the row of the root files, the files no track holds. Default: DefaultRootFiles.
    public string root_files { get; }

    // The header of the column of the unlisted files, the files no file language names. Default: DefaultUnlistedFiles.
    public string unlisted_files { get; }

    // The legend entry of the file-count scale. Default: DefaultLegendFiles.
    public string legend_files { get; }

    // The legend entry of the stack-violation mark. Default: DefaultLegendViolation.
    public string legend_violation { get; }

    // The legend entry of a lit cell's outline. Default: DefaultLegendHighlight.
    public string legend_highlight { get; }

    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    public MapsLabels(string gridTitle, string treeTitle, string rowAxis, string columnAxis, string rootFiles, string unlistedFiles,
        string legendFiles, string legendViolation, string legendHighlight)
    {
        grid_title = gridTitle;
        tree_title = treeTitle;
        row_axis = rowAxis;
        column_axis = columnAxis;
        root_files = rootFiles;
        unlisted_files = unlistedFiles;
        legend_files = legendFiles;
        legend_violation = legendViolation;
        legend_highlight = legendHighlight;
    }
}
