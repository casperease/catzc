/*
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.Maps/types/MapsPalette.cs
    folder: types
    name: maps-palette
    filetype: cs
    role: type
    language: csharp
    track: pwsh
    tracktype: modules
    module: Catzc.Base.Maps
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    docs: "[MapsPalette.cs.md](docs/references/pwsh/catzc-base-maps/types/MapsPalette.cs.md)"
    cites:
      - ADR-AUTO-DEFAULT-ONERESOLUTIONORDER
      - ADR-BCL-TYPES-SNAKECASEMIRRORSYAML
---
*/

namespace Catzc.Base.Maps;

public sealed class MapsPalette
{
    public const string DefaultBackground = "#1E2430";
    public const string DefaultRow = "#262E3B";
    public const string DefaultColumn = "#262E3B";
    public const string DefaultCell = "#262E3B";
    public const string DefaultShade = "#DDE2E9";
    public const string DefaultLine = "#3A4555";
    public const string DefaultText = "#CDD3DC";
    public const string DefaultViolation = "#E57373";
    public const string DefaultHighlight = "#E6EAF0";

    // The fill of the whole page, drawn first so a viewer in dark or light mode shows it. Default: DefaultBackground.
    public string background { get; }

    // The fill of a track's row header. Default: DefaultRow.
    public string row { get; }

    // The fill of a file language's column header. Default: DefaultColumn.
    public string column { get; }

    // The fill of an empty cell, and the idle end of the file-count scale. Default: DefaultCell.
    public string cell { get; }

    // The fill of the fullest cell, the lit end of the file-count scale. Default: DefaultShade.
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
