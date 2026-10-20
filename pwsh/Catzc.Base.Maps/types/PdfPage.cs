/*
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.Maps/types/PdfPage.cs
    folder: types
    name: pdf-page
    filetype: cs
    role: type
    language: csharp
    track: pwsh
    tracktype: modules
    module: Catzc.Base.Maps
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    test: pwsh/Catzc.Base.Maps/tests/types/PdfPage.Tests.ps1
    docs: "[PdfPage.cs.md](docs/references/pwsh/catzc-base-maps/types/PdfPage.cs.md)"
    cites:
      - ADR-PWSH-TYPES-HOSTGUARANTEEDASSEMBLIES
---
*/

using System;
using System.Text;

namespace Catzc.Base.Maps;

[Catzc.Base.Objects.ConsoleDisplay(nameof(Width), nameof(Height), nameof(OperationCount))]
public sealed class PdfPage
{
    // The largest page side PDF 1.4 allows, in points (200 inches).
    public const double MaxSide = 14400;

    private readonly StringBuilder content = new StringBuilder();

    // The page width in points.
    public double Width { get; }

    // The page height in points.
    public double Height { get; }

    // The drawing calls made on the page so far.
    public int OperationCount { get; private set; }

    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    public PdfPage(double width, double height)
    {
        Width = Side(width, nameof(width));
        Height = Side(height, nameof(height));
    }

    // The content stream: every operator line, each ending in '\n'.
    public string Content => content.ToString();

    // The colour of later fills (rg), each component from 0 to 1.
    public PdfPage SetFillColor(double red, double green, double blue) =>
        Append(Component(red, nameof(red)) + " " + Component(green, nameof(green)) + " " + Component(blue, nameof(blue)) + " rg");

    // The colour of later fills (rg), as '#' and six hex digits.
    public PdfPage SetFillColor(string hex) => Append(Hex(hex) + " rg");

    // The colour of later strokes (RG), each component from 0 to 1.
    public PdfPage SetStrokeColor(double red, double green, double blue) =>
        Append(Component(red, nameof(red)) + " " + Component(green, nameof(green)) + " " + Component(blue, nameof(blue)) + " RG");

    // The colour of later strokes (RG), as '#' and six hex digits.
    public PdfPage SetStrokeColor(string hex) => Append(Hex(hex) + " RG");

    // The width of later strokes (w), in points; zero is the thinnest line the device can draw.
    public PdfPage SetLineWidth(double width)
    {
        if (double.IsNaN(width) || width < 0)
        {
            throw new ArgumentOutOfRangeException(nameof(width), width, "A line width must be zero or more.");
        }
        return Append(PdfNumber.Format(width) + " w");
    }

    // A rectangle filled with the fill colour (re f); x and y are its bottom-left corner.
    public PdfPage FillRect(double x, double y, double width, double height) => Append(Rect(x, y, width, height) + " re f");

    // A rectangle outlined with the stroke colour and line width (re S); x and y are its bottom-left corner.
    public PdfPage StrokeRect(double x, double y, double width, double height) => Append(Rect(x, y, width, height) + " re S");

    // A straight line from (x1, y1) to (x2, y2), stroked (m l S).
    public PdfPage Line(double x1, double y1, double x2, double y2) =>
        Append(PdfNumber.Format(x1) + " " + PdfNumber.Format(y1) + " m " + PdfNumber.Format(x2) + " " + PdfNumber.Format(y2) + " l S");

    public PdfPage Text(PdfFont font, double size, double x, double y, string text)
    {
        if (double.IsNaN(size) || size <= 0)
        {
            throw new ArgumentOutOfRangeException(nameof(size), size, "A font size must be more than zero.");
        }
        return Append("BT /" + FontName(font) + " " + PdfNumber.Format(size) + " Tf " + PdfNumber.Format(x) + " " + PdfNumber.Format(y) +
            " Td (" + Escape(text) + ") Tj ET");
    }

    // The resource name PdfDocument gives a font: /F1 for Helvetica, /F2 for Helvetica-Bold.
    public static string FontName(PdfFont font)
    {
        switch (font)
        {
            case PdfFont.Helvetica: return "F1";
            case PdfFont.HelveticaBold: return "F2";
            default: throw new ArgumentOutOfRangeException(nameof(font), font, "Not a base-14 font PdfDocument writes.");
        }
    }

    public static string Escape(string text)
    {
        if (text == null) { throw new ArgumentNullException(nameof(text)); }
        int bad = WinAnsi.IndexOfUnsupported(text);
        if (bad >= 0)
        {
            throw new ArgumentException(string.Format(System.Globalization.CultureInfo.InvariantCulture,
                "The text '{0}' has U+{1:X4} at index {2}, which the base-14 fonts cannot show (WinAnsi only).",
                text, (int)text[bad], bad), nameof(text));
        }
        var sb = new StringBuilder(text.Length);
        foreach (char c in text)
        {
            int code = WinAnsi.CodeOf(c);
            if (c == '(' || c == ')' || c == '\\') { sb.Append('\\').Append(c); }
            else if (code >= 0x80) { sb.Append('\\').Append(Convert.ToString(code, 8)); }
            else { sb.Append((char)code); }
        }
        return sb.ToString();
    }

    private PdfPage Append(string line)
    {
        content.Append(line).Append('\n');
        OperationCount++;
        return this;
    }

    private static string Rect(double x, double y, double width, double height) =>
        PdfNumber.Format(x) + " " + PdfNumber.Format(y) + " " + PdfNumber.Format(width) + " " + PdfNumber.Format(height);

    private static string Component(double value, string name)
    {
        if (double.IsNaN(value) || value < 0 || value > 1)
        {
            throw new ArgumentOutOfRangeException(name, value, "A colour component runs from 0 to 1.");
        }
        return PdfNumber.Format(value);
    }

    private static string Hex(string hex)
    {
        if (hex == null || hex.Length != 7 || hex[0] != '#' || !IsHex(hex.Substring(1)))
        {
            throw new ArgumentException("A colour is '#' and six hex digits, not '" + hex + "'.", nameof(hex));
        }
        return Channel(hex, 1) + " " + Channel(hex, 3) + " " + Channel(hex, 5);
    }

    private static bool IsHex(string digits)
    {
        foreach (char c in digits)
        {
            if (!Uri.IsHexDigit(c)) { return false; }
        }
        return true;
    }

    private static string Channel(string hex, int start) =>
        PdfNumber.Format(Convert.ToInt32(hex.Substring(start, 2), 16) / 255.0);

    private static double Side(double value, string name)
    {
        if (double.IsNaN(value) || value <= 0 || value > MaxSide)
        {
            throw new ArgumentOutOfRangeException(name, value, "A page side runs from more than 0 to 14400 points.");
        }
        return value;
    }
}
