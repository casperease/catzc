/*
---
catzc:
  immutable:
    path: automation/Catzc.Base.Maps/types/MapsLimits.cs
    folder: types
    name: maps-limits
    filetype: cs
    kind: type
    language: csharp
    track: automation
    module: Catzc.Base.Maps
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    page: docs/references/automation/catzc-base-maps/types/MapsLimits.cs.md
    cites:
      - ADR-AUTO-DEFAULT#6
      - ADR-AUTO-TYPES#8
---
*/

namespace Catzc.Base.Maps;

public sealed class MapsLimits
{
    public const double DefaultPageWidth = 842;
    public const double DefaultPageHeight = 595;
    public const double DefaultMinFontSize = 6;
    public const int DefaultMaxRowLabel = 24;
    public const int DefaultMaxColumnLabel = 16;

    // The page width, in PDF points (1/72 inch). Default: DefaultPageWidth.
    public double page_width { get; }

    // The page height, in PDF points. Default: DefaultPageHeight.
    public double page_height { get; }

    // The smallest font size a label may shrink to, in PDF points. Default: DefaultMinFontSize.
    public double min_font_size { get; }

    // The most characters a row header (a track name) prints. Default: DefaultMaxRowLabel.
    public int max_row_label { get; }

    // The most characters a column header (a file-language name) prints. Default: DefaultMaxColumnLabel.
    public int max_column_label { get; }

    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    public MapsLimits(double pageWidth, double pageHeight, double minFontSize, int maxRowLabel, int maxColumnLabel)
    {
        page_width = pageWidth;
        page_height = pageHeight;
        min_font_size = minFontSize;
        max_row_label = maxRowLabel;
        max_column_label = maxColumnLabel;
    }
}
