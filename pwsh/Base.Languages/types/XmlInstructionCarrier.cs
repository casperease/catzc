// A generated xml file's stamp: one <?catzc ...?> processing instruction on its own line, below the xml declaration when there is one.

using System;
using System.Text.RegularExpressions;

namespace Catzc.Base.Languages;

public static class XmlInstructionCarrier
{
    // The target of the stamp's processing instruction.
    public const string Target = "catzc";

    private static readonly Regex Stamp = new Regex(@"<\?" + Target + @"(?=\s|\?>).*?\?>(\r?\n)?", RegexOptions.Singleline | RegexOptions.CultureInvariant);
    private static readonly Regex Declaration = new Regex(@"\A(﻿)?<\?xml\s.*?\?>(\r?\n)?", RegexOptions.Singleline | RegexOptions.CultureInvariant);

    // The document without its stamp instruction and the line end after it, which the body hash hashes.
    public static string Body(string xml) => Stamp.Replace(xml ?? string.Empty, string.Empty);

    public static string With(string xml, string text)
    {
        string value = text ?? string.Empty;
        if (value.Contains("?>", StringComparison.Ordinal)) { throw new ArgumentException("the xml stamp text may not hold '?>', which would close its instruction"); }
        if (value.StartsWith(Target + ":", StringComparison.Ordinal))
        {
            int end = value.IndexOf('\n');
            value = end < 0 ? string.Empty : value.Substring(end + 1);
        }
        string body = Body(xml);
        string newLine = body.Contains("\r\n", StringComparison.Ordinal) ? "\r\n" : "\n";
        string instruction = "<?" + Target + newLine + value.Replace("\r\n", "\n").Replace("\n", newLine) + newLine + "?>" + newLine;
        Match declaration = Declaration.Match(body);
        int at = 0;
        if (declaration.Success) { at = declaration.Index + declaration.Length; }
        else if (body.StartsWith("﻿", StringComparison.Ordinal)) { at = 1; }
        return body.Substring(0, at) + instruction + body.Substring(at);
    }
}
