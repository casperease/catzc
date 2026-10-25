/*
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-maps/types/WorldMapPdfDrawing.cs.md"
  header: "generated"
---
*/

// The drawing steps of the world-map PDF: a page, its labels, the violation and highlight marks, and the legend.

using System;
using System.Collections.Generic;
using System.Globalization;
using static Catzc.Base.Maps.WorldMapPdf;

namespace Catzc.Base.Maps;

public static class WorldMapPdfDrawing
{
    // A new page: the full-page background first, then the title.
    internal static PdfPage Begin(PdfDocument doc, MapsConfig config, string title)
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
    internal static void Label(PdfPage page, PdfFont font, string text, double x, double y, double width, double height, double min, bool centre)
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

    internal static void ColumnHeader(PdfPage page, string text, double x, double y, double width, double height, double min)
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
    internal static void TreeCellLabel(PdfPage page, string name, int count, TreemapRect cell, double min)
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
    internal static void Violation(PdfPage page, MapsPalette palette, double x, double y, double width, double height)
    {
        page.SetStrokeColor(palette.violation).SetLineWidth(1.5);
        page.StrokeRect(x + 0.75, y + 0.75, Math.Max(0, width - 1.5), Math.Max(0, height - 1.5));
        double corner = Math.Min(5, Math.Min(width, height) / 3);
        page.SetFillColor(palette.violation);
        page.FillRect(x + width - corner, y + height - corner, corner, corner);
    }

    // The highlight outline of a lit cell, inside the cell's edge.
    internal static void Outline(PdfPage page, MapsPalette palette, double x, double y, double width, double height)
    {
        page.SetStrokeColor(palette.highlight).SetLineWidth(2.5);
        page.StrokeRect(x + 1.25, y + 1.25, Math.Max(0, width - 2.5), Math.Max(0, height - 2.5));
    }

    internal static void Legend(PdfPage page, MapsConfig config, int maxCount, WorldMapHighlight highlight)
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
    internal static double Write(PdfPage page, string text, double x, double baseline, double right, double min)
    {
        double fitted;
        string shown = Fit(text, PdfFont.Helvetica, WorldMapGridLayout.LabelSize, min, right - x, out fitted);
        if (shown.Length == 0) { return x; }
        page.Text(PdfFont.Helvetica, fitted, x, baseline, shown);
        return x + HelveticaMetrics.Width(PdfFont.Helvetica, fitted, shown);
    }

    // The counts the legend shows: 1, then up to four steps spread evenly on the logarithmic scale up to the maximum.
    internal static List<int> ScaleSteps(int maxCount)
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
}
