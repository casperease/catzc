// A generated svg's stamp: one <metadata id="catzc"> element, the first child of the root <svg>, holding the stamp text as CDATA.

using System;
using System.Text.RegularExpressions;

namespace Catzc.Base.Languages;

public static class SvgMetadataCarrier
{
    // The id that tells the stamp's metadata element from any other the drawing carries.
    public const string Id = "catzc";

    private const string Open = "<metadata id=\"" + Id + "\"><![CDATA[";
    private const string Close = "]]></metadata>";

    private static readonly Regex Stamp = new Regex("<metadata id=\"" + Id + "\">.*?</metadata>", RegexOptions.Singleline | RegexOptions.CultureInvariant);
    private static readonly Regex Root = new Regex(@"<svg\b[^>]*>", RegexOptions.CultureInvariant);

    // The drawing without its stamp element, which the body hash hashes; every other character is kept as it is.
    public static string Body(string svg) => Stamp.Replace(svg ?? string.Empty, string.Empty);

    // The drawing with the stamp text as the first child of its root; a stamp already there is replaced, so a second run changes nothing.
    public static string With(string svg, string text)
    {
        string value = text ?? string.Empty;
        if (value.Contains("]]>", StringComparison.Ordinal)) { throw new ArgumentException("the svg stamp text may not hold ']]>', which would close its CDATA"); }
        string body = Body(svg);
        Match root = Root.Match(body);
        if (!root.Success) { throw new ArgumentException("the text is no svg: it has no <svg> start tag"); }
        if (root.Value.EndsWith("/>", StringComparison.Ordinal)) { throw new ArgumentException("the svg root is an empty element, so it has no place for a metadata child"); }
        int at = root.Index + root.Length;
        return body.Substring(0, at) + Open + value + Close + body.Substring(at);
    }
}
