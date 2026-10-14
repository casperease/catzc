// The world-map palette (the `palette` section of configs/maps.yml): the page background, the fill colours of the track
// rows, the file-language columns, an empty cell and the fullest cell, the grid lines, the text, a stack-violation mark
// and a highlighted (lit) cell's outline, each a '#' and six hex digits. The properties mirror the YAML keys, so they are
// snake_case ([ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)). The defaults
// are declared here, once ([ADR-AUTO-DEFAULT#6](/docs/adr/automation/sensible-defaults.md#rule-adr-auto-default6)), and
// chosen to read on the light grey-blue background: dark text, a white empty cell, a blue scale, a red mark and an amber
// outline. MapsConfig validates the section and builds one.

namespace Catzc.Base.Maps;

public sealed class MapsPalette
{
    public const string DefaultBackground = "#E6ECF2";
    public const string DefaultRow = "#DCE6F0";
    public const string DefaultColumn = "#E8E8E8";
    public const string DefaultCell = "#FFFFFF";
    public const string DefaultShade = "#2B6CB0";
    public const string DefaultLine = "#9AA8B8";
    public const string DefaultText = "#1F2933";
    public const string DefaultViolation = "#C62828";
    public const string DefaultHighlight = "#F4B942";

    // The fill of the whole page, drawn first so a viewer in dark or light mode shows it. Default: DefaultBackground.
    public string background { get; }

    // The fill of a track's row header. Default: DefaultRow.
    public string row { get; }

    // The fill of a file language's column header. Default: DefaultColumn.
    public string column { get; }

    // The fill of an empty cell, and the light end of the file-count scale. Default: DefaultCell.
    public string cell { get; }

    // The fill of the fullest cell, the dark end of the file-count scale. Default: DefaultShade.
    public string shade { get; }

    // The colour of the grid lines and the outlines. Default: DefaultLine.
    public string line { get; }

    // The colour of the titles, headers and counts. Default: DefaultText.
    public string text { get; }

    // The mark of a cell that breaks its track's tech-stack. Default: DefaultViolation.
    public string violation { get; }

    // The outline of a lit cell. Default: DefaultHighlight.
    public string highlight { get; }

    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    public MapsPalette(string background, string row, string column, string cell, string shade, string line, string text, string violation,
        string highlight)
    {
        this.background = background;
        this.row = row;
        this.column = column;
        this.cell = cell;
        this.shade = shade;
        this.line = line;
        this.text = text;
        this.violation = violation;
        this.highlight = highlight;
    }
}
