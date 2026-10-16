/*
---
catzc:
  derived:
    path: automation/Catzc.Base.Maps/types/WorldMapPdf.cs
    folder: types
    name: world-map-pdf
    filetype: cs
    kind: type
    language: csharp
    track: automation
    module: Catzc.Base.Maps
    moduletype: pwsh-folder
    catzc_bundle: azure
    relatives:
      page: docs/references/automation/catzc-base-maps/types/WorldMapPdf.cs.md
      test: automation/Catzc.Base.Maps/tests/types/WorldMapPdf.Tests.ps1
    adrs:
      - ADR-DSGN-TRACK#{3,7,8}
---
*/

using System;
using System.Collections.Generic;
using System.Globalization;

namespace Catzc.Base.Maps;

public static class WorldMapPdf
{
    // The marker that ends a cut label (WinAnsi 0x85).
    public const string TruncationMarker = "…";

    // The share of the colour scale the smallest non-empty count starts at, so one file still reads as filled.
    private const double ScaleFloor = 0.15;

    // Above this share of the scale a count is printed in the light colour.
    private const double DarkFrom = 0.55;

    // The thickness of a track's name band on the tree page.
    private const double TreeBand = 12;

    // The document holding the grid page, the tree page, or both (grid first). The highlight is optional (null).
    public static PdfDocument Render(WorldMap map, MapsConfig config, WorldMapHighlight highlight, bool grid, bool tree)
    {
        if (!grid && !tree) { throw new ArgumentException("world-map PDF: no view requested (grid, tree, or both)"); }
        PdfDocument doc = new PdfDocument();
        if (grid) { AddGridPage(doc, map, config, highlight); }
        if (tree) { AddTreePage(doc, map, config, highlight); }
        return doc;
    }

    // The printed header of a row: the root-file label for the catch-all row, else the track name cut to max_row_label.
    public static string RowLabel(string track, MapsConfig config)
    {
        if (config == null) { throw new ArgumentNullException(nameof(config)); }
        return string.Equals(track, WorldMap.NoTrack, StringComparison.Ordinal) ? config.labels.root_files : Truncate(track, config.limits.max_row_label);
    }

    public static string ColumnLabel(string fileLanguage, MapsConfig config)
    {
        if (config == null) { throw new ArgumentNullException(nameof(config)); }
        return string.Equals(fileLanguage, WorldMap.NoFileLanguage, StringComparison.Ordinal)
            ? config.labels.unlisted_files
            : Truncate(fileLanguage, config.limits.max_column_label);
    }

    public static string Truncate(string text, int maxChars)
    {
        if (text == null) { throw new ArgumentNullException(nameof(text)); }
        if (maxChars < 1) { throw new ArgumentOutOfRangeException(nameof(maxChars), maxChars, "A label keeps at least one character."); }
        if (text.Length <= maxChars) { return text; }
        return text.Substring(0, maxChars - 1) + TruncationMarker;
    }

    public static string Fit(string text, PdfFont font, double size, double minSize, double maxWidth, out double fittedSize)
    {
        if (text == null) { throw new ArgumentNullException(nameof(text)); }
        fittedSize = 0;
        if (text.Length == 0 || maxWidth <= 0 || minSize > size) { return ""; }
        double width = HelveticaMetrics.Width(font, size, text);
        if (width <= maxWidth)
        {
            fittedSize = size;
            return text;
        }
        double shrunk = Math.Floor(size * maxWidth / width * 2) / 2;
        if (shrunk >= minSize && HelveticaMetrics.Width(font, shrunk, text) <= maxWidth)
        {
            fittedSize = shrunk;
            return text;
        }
        for (int keep = text.Length - 1; keep >= 1; keep--)
        {
            string cut = text.Substring(0, keep) + TruncationMarker;
            if (HelveticaMetrics.Width(font, minSize, cut) <= maxWidth)
            {
                fittedSize = minSize;
                return cut;
            }
        }
        return "";
    }

    public static string[] FitLines(string text, PdfFont font, double size, double minSize, double maxWidth, out double fittedSize)
    {
        if (text == null) { throw new ArgumentNullException(nameof(text)); }
        fittedSize = 0;
        if (text.Length == 0 || maxWidth <= 0 || minSize > size) { return Array.Empty<string>(); }
        if (HelveticaMetrics.Width(font, size, text) <= maxWidth)
        {
            fittedSize = size;
            return new[] { text };
        }
        string[] split = BestBreak(text, font);
        if (split == null)
        {
            string one = Fit(text, font, size, minSize, maxWidth, out fittedSize);
            return one.Length == 0 ? Array.Empty<string>() : new[] { one };
        }
        double wider = Math.Max(HelveticaMetrics.Width(font, size, split[0]), HelveticaMetrics.Width(font, size, split[1]));
        if (wider <= maxWidth)
        {
            fittedSize = size;
            return split;
        }
        double shrunk = Math.Floor(size * maxWidth / wider * 2) / 2;
        if (shrunk >= minSize && Math.Max(HelveticaMetrics.Width(font, shrunk, split[0]), HelveticaMetrics.Width(font, shrunk, split[1])) <= maxWidth)
        {
            fittedSize = shrunk;
            return split;
        }
        double cutSize;
        string top = Fit(split[0], font, minSize, minSize, maxWidth, out cutSize);
        if (top.Length == 0) { return Array.Empty<string>(); }
        string bottom = Fit(split[1], font, minSize, minSize, maxWidth, out cutSize);
        fittedSize = minSize;
        return bottom.Length == 0 ? new[] { top } : new[] { top, bottom };
    }

    private static string[] BestBreak(string text, PdfFont font)
    {
        string[] best = null;
        double bestWidth = double.MaxValue;
        for (int at = 0; at < text.Length; at++)
        {
            string first, second;
            if (text[at] == ' ')
            {
                first = text.Substring(0, at).TrimEnd(' ');
                second = text.Substring(at + 1).TrimStart(' ');
            }
            else if (text[at] == '-')
            {
                first = text.Substring(0, at + 1);
                second = text.Substring(at + 1);
            }
            else { continue; }
            if (first.Trim(' ', '-').Length == 0 || second.Trim(' ', '-').Length == 0) { continue; }
            double width = Math.Max(HelveticaMetrics.Width(font, 1, first), HelveticaMetrics.Width(font, 1, second));
            if (width < bestWidth)
            {
                best = new[] { first, second };
                bestWidth = width;
            }
        }
        return best;
    }

    public static string ShadeOf(int count, int maxCount, MapsPalette palette)
    {
        if (palette == null) { throw new ArgumentNullException(nameof(palette)); }
        if (count <= 0 || maxCount <= 0) { return palette.cell; }
        return Mix(palette.cell, palette.shade, Share(count, maxCount));
    }

    // The colour a share t (0 to 1) of the way from one colour to another, each '#' and six hex digits.
    public static string Mix(string from, string to, double t)
    {
        double share = Math.Max(0, Math.Min(1, t));
        string result = "#";
        for (int at = 1; at < 7; at += 2)
        {
            int a = Convert.ToInt32(from.Substring(at, 2), 16);
            int b = Convert.ToInt32(to.Substring(at, 2), 16);
            int mixed = (int)Math.Round(a + (b - a) * share, MidpointRounding.AwayFromZero);
            result += mixed.ToString("X2", CultureInfo.InvariantCulture);
        }
        return result;
    }

    public static void AddGridPage(PdfDocument doc, WorldMap map, MapsConfig config, WorldMapHighlight highlight)
    {
        Check(doc, map, config);
        WorldMapGridLayout layout = new WorldMapGridLayout(map, config);
        MapsPalette palette = config.palette;
        double min = config.limits.min_font_size;
        PdfPage page = Begin(doc, config, config.labels.grid_title);
        int maxCount = MaxCount(map);

        // The headers.
        page.SetFillColor(palette.row);
        page.FillRect(layout.Left, layout.Bottom, layout.RowHeaderWidth, layout.Rows * layout.CellHeight);
        page.SetFillColor(palette.column);
        page.FillRect(layout.CellLeft(0), layout.Top - layout.ColumnHeaderHeight, layout.Columns * layout.CellWidth, layout.ColumnHeaderHeight);
        double axisHeight = layout.ColumnAxisHeight;
        page.SetFillColor(palette.text);
        Label(page, PdfFont.HelveticaBold, config.labels.column_axis, layout.CellLeft(0), layout.Top - axisHeight, layout.Columns * layout.CellWidth,
            axisHeight, min, false);
        Label(page, PdfFont.HelveticaBold, config.labels.row_axis, layout.Left, layout.Top - layout.ColumnHeaderHeight, layout.RowHeaderWidth, axisHeight,
            min, false);
        for (int c = 0; c < layout.Columns; c++)
        {
            ColumnHeader(page, ColumnLabel(map.FileLanguages[c], config), layout.CellLeft(c), layout.Top - layout.ColumnHeaderHeight, layout.CellWidth,
                layout.ColumnNameHeight, min);
        }
        for (int r = 0; r < layout.Rows; r++)
        {
            Label(page, PdfFont.Helvetica, RowLabel(map.Tracks[r], config), layout.Left, layout.CellBottom(r), layout.RowHeaderWidth, layout.CellHeight,
                min, false);
        }

        // The cells, then the grid lines over them, then the counts.
        for (int r = 0; r < layout.Rows; r++)
        {
            for (int c = 0; c < layout.Columns; c++)
            {
                MapCell cell = map.Cell(map.Tracks[r], map.FileLanguages[c]);
                page.SetFillColor(ShadeOf(cell.FileCount, maxCount, palette));
                page.FillRect(layout.CellLeft(c), layout.CellBottom(r), layout.CellWidth, layout.CellHeight);
            }
        }
        page.SetStrokeColor(palette.line).SetLineWidth(0.5);
        for (int r = 0; r <= layout.Rows; r++)
        {
            double y = layout.Top - layout.ColumnHeaderHeight - r * layout.CellHeight;
            page.Line(layout.Left, y, layout.Right, y);
        }
        page.Line(layout.CellLeft(0), layout.Top, layout.Right, layout.Top);
        page.Line(layout.Left, layout.Top - layout.ColumnHeaderHeight, layout.Left, layout.Bottom);
        for (int c = 0; c <= layout.Columns; c++)
        {
            double x = layout.Left + layout.RowHeaderWidth + c * layout.CellWidth;
            page.Line(x, c == 0 || c == layout.Columns ? layout.Top : layout.Top - axisHeight, x, layout.Bottom);
        }
        page.SetLineWidth(1.5);
        double bucketY = layout.CellBottom(layout.Rows - 1) + layout.CellHeight;
        page.Line(layout.Left, bucketY, layout.Right, bucketY);
        double bucketX = layout.CellLeft(layout.Columns - 1);
        page.Line(bucketX, layout.Top - axisHeight, bucketX, layout.Bottom);

        for (int r = 0; r < layout.Rows; r++)
        {
            for (int c = 0; c < layout.Columns; c++)
            {
                MapCell cell = map.Cell(map.Tracks[r], map.FileLanguages[c]);
                if (cell.FileCount == 0) { continue; }
                page.SetFillColor(Share(cell.FileCount, maxCount) > DarkFrom ? palette.cell : palette.text);
                Label(page, PdfFont.Helvetica, cell.FileCount.ToString(CultureInfo.InvariantCulture), layout.CellLeft(c), layout.CellBottom(r),
                    layout.CellWidth, layout.CellHeight, min, true);
            }
        }

        // The marks and outlines, last so nothing covers them.
        for (int r = 0; r < layout.Rows; r++)
        {
            for (int c = 0; c < layout.Columns; c++)
            {
                if (map.Cell(map.Tracks[r], map.FileLanguages[c]).StackViolation)
                {
                    Violation(page, palette, layout.CellLeft(c), layout.CellBottom(r), layout.CellWidth, layout.CellHeight);
                }
            }
        }
        foreach (HighlightedCell lit in LitCells(map, highlight))
        {
            int r = IndexOf(map.Tracks, lit.Track);
            int c = IndexOf(map.FileLanguages, lit.FileLanguage);
            Outline(page, palette, layout.CellLeft(c), layout.CellBottom(r), layout.CellWidth, layout.CellHeight);
        }
        Legend(page, config, maxCount, highlight);
    }

    public static void AddTreePage(PdfDocument doc, WorldMap map, MapsConfig config, WorldMapHighlight highlight)
    {
        Check(doc, map, config);
        MapsPalette palette = config.palette;
        double min = config.limits.min_font_size;
        double width = config.limits.page_width, height = config.limits.page_height;
        PdfPage page = Begin(doc, config, config.labels.tree_title);
        int maxCount = MaxCount(map);
        double margin = WorldMapGridLayout.Margin;
        double top = height - margin - 2 * WorldMapGridLayout.TitleSize;
        double bottom = margin + WorldMapGridLayout.LegendHeight + WorldMapGridLayout.Padding;
        if (top - bottom <= 0 || width - 2 * margin <= 0)
        {
            throw new ArgumentException(string.Format(CultureInfo.InvariantCulture, "world-map tree: a {0} x {1} page has no room for the map", width, height));
        }

        List<string> keys = new List<string>();
        List<double> weights = new List<double>();
        foreach (string track in map.Tracks)
        {
            keys.Add(track);
            weights.Add(RowTotal(map, track));
        }
        TreemapRect[] tracks = SquarifiedTreemap.Layout(keys.ToArray(), weights.ToArray(), margin, bottom, width - 2 * margin, top - bottom);
        Dictionary<string, TreemapRect> cellBoxes = new Dictionary<string, TreemapRect>(StringComparer.Ordinal);

        foreach (TreemapRect box in tracks)
        {
            page.SetFillColor(palette.row);
            page.FillRect(box.X, box.Y, box.Width, box.Height);
            double fitted;
            string name = Fit(RowLabel(box.Key, config), PdfFont.HelveticaBold, WorldMapGridLayout.LabelSize, min,
                box.Width - 2 * WorldMapGridLayout.Padding, out fitted);
            double innerTop = box.Y + box.Height;
            if (name.Length > 0 && box.Height > TreeBand + 2 * WorldMapGridLayout.Padding)
            {
                page.SetFillColor(palette.text);
                page.Text(PdfFont.HelveticaBold, fitted, box.X + WorldMapGridLayout.Padding, innerTop - WorldMapGridLayout.Padding - fitted * 0.75, name);
                innerTop -= TreeBand;
            }
            double inset = 2;
            double innerWidth = box.Width - 2 * inset, innerHeight = innerTop - box.Y - inset;
            if (innerWidth <= 0 || innerHeight <= 0) { continue; }

            List<string> languages = new List<string>();
            List<double> counts = new List<double>();
            foreach (string fileLanguage in map.FileLanguages)
            {
                languages.Add(fileLanguage);
                counts.Add(map.Cell(box.Key, fileLanguage).FileCount);
            }
            TreemapRect[] cells = SquarifiedTreemap.Layout(languages.ToArray(), counts.ToArray(), box.X + inset, box.Y + inset, innerWidth, innerHeight);
            foreach (TreemapRect cell in cells)
            {
                cellBoxes[box.Key + "\u0000" + cell.Key] = cell;
                int count = (int)cell.Weight;
                page.SetFillColor(ShadeOf(count, maxCount, palette));
                page.FillRect(cell.X, cell.Y, cell.Width, cell.Height);
                page.SetStrokeColor(palette.line).SetLineWidth(0.5);
                page.StrokeRect(cell.X, cell.Y, cell.Width, cell.Height);
                page.SetFillColor(Share(count, maxCount) > DarkFrom ? palette.cell : palette.text);
                TreeCellLabel(page, ColumnLabel(cell.Key, config), count, cell, min);
            }
            page.SetStrokeColor(palette.line).SetLineWidth(1);
            page.StrokeRect(box.X, box.Y, box.Width, box.Height);
        }

        foreach (TreemapRect box in tracks)
        {
            foreach (string fileLanguage in map.FileLanguages)
            {
                TreemapRect cell;
                if (map.Cell(box.Key, fileLanguage).StackViolation && cellBoxes.TryGetValue(box.Key + "\u0000" + fileLanguage, out cell))
                {
                    Violation(page, palette, cell.X, cell.Y, cell.Width, cell.Height);
                }
            }
        }
        foreach (HighlightedCell lit in LitCells(map, highlight))
        {
            TreemapRect cell;
            if (cellBoxes.TryGetValue(lit.Track + "\u0000" + lit.FileLanguage, out cell))
            {
                Outline(page, palette, cell.X, cell.Y, cell.Width, cell.Height);
            }
        }
        Legend(page, config, maxCount, highlight);
    }

    private static void Check(PdfDocument doc, WorldMap map, MapsConfig config)
    {
        if (doc == null) { throw new ArgumentNullException(nameof(doc)); }
        if (map == null) { throw new ArgumentNullException(nameof(map)); }
        if (config == null) { throw new ArgumentNullException(nameof(config)); }
    }

    // A new page: the full-page background first, then the title.
    private static PdfPage Begin(PdfDocument doc, MapsConfig config, string title)
    {
        double width = config.limits.page_width, height = config.limits.page_height;
        PdfPage page = doc.AddPage(width, height);
        page.SetFillColor(config.palette.background).FillRect(0, 0, width, height);
        double fitted;
        string text = Fit(title, PdfFont.HelveticaBold, WorldMapGridLayout.TitleSize, config.limits.min_font_size,
            width - 2 * WorldMapGridLayout.Margin, out fitted);
        if (text.Length > 0)
        {
            page.SetFillColor(config.palette.text);
            page.Text(PdfFont.HelveticaBold, fitted, WorldMapGridLayout.Margin, height - WorldMapGridLayout.Margin - WorldMapGridLayout.TitleSize, text);
        }
        return page;
    }

    // One label fitted into a box and set on its vertical middle, centred or left-aligned, in the current fill colour.
    private static void Label(PdfPage page, PdfFont font, string text, double x, double y, double width, double height, double min, bool centre)
    {
        double pad = WorldMapGridLayout.Padding;
        double size = Math.Min(WorldMapGridLayout.LabelSize, height - 2 * pad);
        if (size < min) { return; }
        double fitted;
        string shown = Fit(text, font, size, min, width - 2 * pad, out fitted);
        if (shown.Length == 0) { return; }
        double textWidth = HelveticaMetrics.Width(font, fitted, shown);
        double left = centre ? x + (width - textWidth) / 2 : x + pad;
        page.Text(font, fitted, left, y + (height - fitted * 0.7) / 2, shown);
    }

    private static void ColumnHeader(PdfPage page, string text, double x, double y, double width, double height, double min)
    {
        double fitted;
        string[] lines = FitLines(text, PdfFont.Helvetica, WorldMapGridLayout.LabelSize, min, width - 2 * WorldMapGridLayout.Padding, out fitted);
        if (lines.Length == 0) { return; }
        double pitch = fitted * WorldMapGridLayout.LineSpacing;
        double baseline = y + (height - (lines.Length - 1) * pitch - fitted * 0.7) / 2 + (lines.Length - 1) * pitch;
        foreach (string line in lines)
        {
            double lineWidth = HelveticaMetrics.Width(PdfFont.Helvetica, fitted, line);
            page.Text(PdfFont.Helvetica, fitted, x + (width - lineWidth) / 2, baseline, line);
            baseline -= pitch;
        }
    }

    // A tree cell's label: its file-language name over its count when both lines fit, else the name alone.
    private static void TreeCellLabel(PdfPage page, string name, int count, TreemapRect cell, double min)
    {
        double pad = WorldMapGridLayout.Padding;
        double size = WorldMapGridLayout.LabelSize - 1;
        double fitted;
        string shown = Fit(name, PdfFont.Helvetica, size, min, cell.Width - 2 * pad, out fitted);
        if (shown.Length == 0 || cell.Height < fitted + 2 * pad) { return; }
        double top = cell.Y + cell.Height - pad - fitted * 0.75;
        page.Text(PdfFont.Helvetica, fitted, cell.X + pad, top, shown);
        string number = count.ToString(CultureInfo.InvariantCulture);
        if (cell.Height >= 2 * fitted + 3 * pad && HelveticaMetrics.Width(PdfFont.Helvetica, fitted, number) <= cell.Width - 2 * pad)
        {
            page.Text(PdfFont.Helvetica, fitted, cell.X + pad, top - fitted - pad, number);
        }
    }

    // The stack-violation mark: an inner border and a corner square in the violation colour.
    private static void Violation(PdfPage page, MapsPalette palette, double x, double y, double width, double height)
    {
        page.SetStrokeColor(palette.violation).SetLineWidth(1.5);
        page.StrokeRect(x + 0.75, y + 0.75, Math.Max(0, width - 1.5), Math.Max(0, height - 1.5));
        double corner = Math.Min(5, Math.Min(width, height) / 3);
        page.SetFillColor(palette.violation);
        page.FillRect(x + width - corner, y + height - corner, corner, corner);
    }

    // The highlight outline of a lit cell, inside the cell's edge.
    private static void Outline(PdfPage page, MapsPalette palette, double x, double y, double width, double height)
    {
        page.SetStrokeColor(palette.highlight).SetLineWidth(2.5);
        page.StrokeRect(x + 1.25, y + 1.25, Math.Max(0, width - 2.5), Math.Max(0, height - 2.5));
    }

    private static void Legend(PdfPage page, MapsConfig config, int maxCount, WorldMapHighlight highlight)
    {
        MapsPalette palette = config.palette;
        double min = config.limits.min_font_size;
        double size = WorldMapGridLayout.LabelSize;
        double swatch = 12;
        double y = WorldMapGridLayout.Margin;
        double x = WorldMapGridLayout.Margin;
        double right = config.limits.page_width - WorldMapGridLayout.Margin;
        double baseline = y + (swatch - size * 0.7) / 2;

        page.SetFillColor(palette.text);
        x = Write(page, config.labels.legend_files, x, baseline, right, min) + 6;
        foreach (int step in ScaleSteps(maxCount))
        {
            if (x + swatch > right) { return; }
            page.SetFillColor(ShadeOf(step, maxCount, palette)).FillRect(x, y, swatch, swatch);
            page.SetStrokeColor(palette.line).SetLineWidth(0.5).StrokeRect(x, y, swatch, swatch);
            page.SetFillColor(palette.text);
            x = Write(page, step.ToString(CultureInfo.InvariantCulture), x + swatch + 2, baseline, right, min) + 6;
        }
        x += 10;
        if (x + swatch > right) { return; }
        page.SetFillColor(palette.cell).FillRect(x, y, swatch, swatch);
        Violation(page, palette, x, y, swatch, swatch);
        page.SetFillColor(palette.text);
        x = Write(page, config.labels.legend_violation, x + swatch + 4, baseline, right, min) + 16;
        if (highlight == null || x + swatch > right) { return; }
        page.SetFillColor(palette.cell).FillRect(x, y, swatch, swatch);
        Outline(page, palette, x, y, swatch, swatch);
        page.SetFillColor(palette.text);
        string request = highlight.Requested.Count == 0 ? config.labels.legend_highlight
            : config.labels.legend_highlight + ": " + string.Join(", ", highlight.Requested);
        Write(page, request, x + swatch + 4, baseline, right, min);
    }

    // One legend text from x, fitted to the room left before right; returns where it ends.
    private static double Write(PdfPage page, string text, double x, double baseline, double right, double min)
    {
        double fitted;
        string shown = Fit(text, PdfFont.Helvetica, WorldMapGridLayout.LabelSize, min, right - x, out fitted);
        if (shown.Length == 0) { return x; }
        page.Text(PdfFont.Helvetica, fitted, x, baseline, shown);
        return x + HelveticaMetrics.Width(PdfFont.Helvetica, fitted, shown);
    }

    // The counts the legend shows: 1, then up to four steps spread evenly on the logarithmic scale up to the maximum.
    private static List<int> ScaleSteps(int maxCount)
    {
        List<int> steps = new List<int>();
        int top = Math.Max(1, maxCount);
        for (int k = 0; k <= 4; k++)
        {
            int step = k == 0 ? 1 : (int)Math.Round(Math.Pow(1 + top, k / 4.0) - 1, MidpointRounding.AwayFromZero);
            step = Math.Max(1, Math.Min(top, step));
            if (!steps.Contains(step)) { steps.Add(step); }
        }
        return steps;
    }

    private static double Share(int count, int maxCount)
    {
        if (count <= 0 || maxCount <= 0) { return 0; }
        return ScaleFloor + (1 - ScaleFloor) * Math.Log(1 + count) / Math.Log(1 + Math.Max(count, maxCount));
    }

    private static int MaxCount(WorldMap map)
    {
        int max = 0;
        foreach (MapCell cell in map.Cells) { max = Math.Max(max, cell.FileCount); }
        return max;
    }

    private static int RowTotal(WorldMap map, string track)
    {
        int total = 0;
        foreach (string fileLanguage in map.FileLanguages) { total += map.Cell(track, fileLanguage).FileCount; }
        return total;
    }

    private static int IndexOf(IReadOnlyList<string> axis, string name)
    {
        for (int i = 0; i < axis.Count; i++)
        {
            if (string.Equals(axis[i], name, StringComparison.Ordinal)) { return i; }
        }
        return -1;
    }

    // The highlight's cells, each checked against the map: a cell the map does not have throws.
    private static IReadOnlyList<HighlightedCell> LitCells(WorldMap map, WorldMapHighlight highlight)
    {
        if (highlight == null) { return Array.Empty<HighlightedCell>(); }
        foreach (HighlightedCell lit in highlight.Cells)
        {
            if (map.Cell(lit.Track, lit.FileLanguage) == null)
            {
                throw new ArgumentException(string.Format(CultureInfo.InvariantCulture,
                    "world-map PDF: the highlight lights the cell '{0}' x '{1}', which the map does not have", lit.Track, lit.FileLanguage));
            }
        }
        return highlight.Cells;
    }
}
