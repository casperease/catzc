/*
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-maps/types/WorldMapGridLayout.cs.md"
  header: "generated"
---
*/

using System;
using System.Globalization;

namespace Catzc.Base.Maps;

[Catzc.Base.Objects.ConsoleDisplay(nameof(Rows), nameof(Columns), nameof(CellWidth), nameof(CellHeight))]
public sealed class WorldMapGridLayout
{
    // The blank border around the page content, in points.
    public const double Margin = 28;

    // The font size of the title.
    public const double TitleSize = 14;

    // The font size the headers and counts start from before they shrink to fit.
    public const double LabelSize = 8;

    // The height of the legend band at the foot of the page.
    public const double LegendHeight = 22;

    // The tallest a cell grows on a page with few rows.
    public const double MaxCellHeight = 40;

    // The padding inside a header or cell around its text.
    public const double Padding = 3;

    // The distance from one baseline to the next in a two-line column header, as a multiple of the font size.
    public const double LineSpacing = 1.2;

    // The page size, in points.
    public double PageWidth { get; }

    public double PageHeight { get; }

    // The baseline of the title.
    public double TitleBaseline { get; }

    // The bottom of the legend band (the legend's swatches sit on it).
    public double LegendBottom { get; }

    // The number of rows (tracks plus the root-file row) and of columns (file languages plus the unlisted-file column).
    public int Rows { get; }

    public int Columns { get; }

    // The left edge of the grid: the row headers start here.
    public double Left { get; }

    // The top edge of the grid: the column headers start here.
    public double Top { get; }

    // The width of the row-header column.
    public double RowHeaderWidth { get; }

    // The height of the column-header band: the column-axis line on top of the file-language name band.
    public double ColumnHeaderHeight => ColumnAxisHeight + ColumnNameHeight;

    // The height of the column-axis line: one line of text.
    public double ColumnAxisHeight { get; }

    // The height of the file-language name band: two lines of text, so a name that wraps keeps the grid aligned.
    public double ColumnNameHeight { get; }

    // The size of one cell.
    public double CellWidth { get; }

    public double CellHeight { get; }

    // The right edge of the last column.
    public double Right => Left + RowHeaderWidth + Columns * CellWidth;

    // The bottom edge of the last row.
    public double Bottom => Top - ColumnHeaderHeight - Rows * CellHeight;

    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    public WorldMapGridLayout(WorldMap map, MapsConfig config)
    {
        if (map == null) { throw new ArgumentNullException(nameof(map)); }
        if (config == null) { throw new ArgumentNullException(nameof(config)); }

        PageWidth = config.limits.page_width;
        PageHeight = config.limits.page_height;
        Rows = map.Tracks.Count;
        Columns = map.FileLanguages.Count;
        TitleBaseline = PageHeight - Margin - TitleSize;
        LegendBottom = Margin;
        Left = Margin;
        Top = TitleBaseline - TitleSize;
        ColumnAxisHeight = LabelSize + 2 * Padding;
        ColumnNameHeight = LabelSize * LineSpacing + LabelSize + 2 * Padding;

        double gridWidth = PageWidth - 2 * Margin;
        double widest = HelveticaMetrics.Width(PdfFont.HelveticaBold, LabelSize, config.labels.row_axis);
        foreach (string track in map.Tracks)
        {
            widest = Math.Max(widest, HelveticaMetrics.Width(PdfFont.Helvetica, LabelSize, WorldMapPdf.RowLabel(track, config)));
        }
        RowHeaderWidth = Math.Min(widest + 2 * Padding, gridWidth / 3);
        CellWidth = (gridWidth - RowHeaderWidth) / Columns;

        double gridHeight = Top - ColumnHeaderHeight - (LegendBottom + LegendHeight + Padding);
        if (CellWidth <= 0 || gridHeight <= 0)
        {
            throw new ArgumentException(string.Format(CultureInfo.InvariantCulture,
                "world-map grid: a {0} x {1} page has no room for {2} rows and {3} columns", PageWidth, PageHeight, Rows, Columns));
        }
        CellHeight = Math.Min(gridHeight / Rows, MaxCellHeight);
    }

    // The left edge of a column (0 is the first file language).
    public double CellLeft(int column)
    {
        if (column < 0 || column >= Columns) { throw new ArgumentOutOfRangeException(nameof(column), column, "No such column."); }
        return Left + RowHeaderWidth + column * CellWidth;
    }

    // The bottom edge of a row (0 is the top row).
    public double CellBottom(int row)
    {
        if (row < 0 || row >= Rows) { throw new ArgumentOutOfRangeException(nameof(row), row, "No such row."); }
        return Top - ColumnHeaderHeight - (row + 1) * CellHeight;
    }
}
