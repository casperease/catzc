// The world-map palette (the `palette` section of configs/maps.yml): the fill colours of the track rows, the
// file-language columns, the cells, and a highlighted (lit) cell, each a '#' and six hex digits. The properties mirror the YAML
// keys, so they are snake_case ([ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)).
// The defaults are declared here, once
// ([ADR-AUTO-DEFAULT#6](/docs/adr/automation/sensible-defaults.md#rule-adr-auto-default6)); MapsConfig validates the
// section and builds one.

namespace Catzc.Base.Maps;

public sealed class MapsPalette
{
    public const string DefaultRow = "#DCE6F0";
    public const string DefaultColumn = "#E8E8E8";
    public const string DefaultCell = "#FFFFFF";
    public const string DefaultHighlight = "#F4B942";

    // The fill of a track's row header. Default: DefaultRow.
    public string row { get; }

    // The fill of a file language's column header. Default: DefaultColumn.
    public string column { get; }

    // The fill of a cell. Default: DefaultCell.
    public string cell { get; }

    // The fill of a lit cell. Default: DefaultHighlight.
    public string highlight { get; }

    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    public MapsPalette(string row, string column, string cell, string highlight)
    {
        this.row = row;
        this.column = column;
        this.cell = cell;
        this.highlight = highlight;
    }
}
