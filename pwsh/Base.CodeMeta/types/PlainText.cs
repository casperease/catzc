/*
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-code-meta/types/PlainText.cs.md"
  header: "generated"
---
*/

using System;
using System.Collections.Generic;
using System.Text.RegularExpressions;

namespace Catzc.Base.CodeMeta;

public static class PlainText
{
    static readonly Regex Link = new Regex(@"\[([^\]]*)\]\([^)]*\)", RegexOptions.CultureInvariant);
    static readonly Regex Code = new Regex(@"\b(?:ADR|DDR|PDR|FDR|TDR)(?:-[A-Z0-9]+)+\b", RegexOptions.CultureInvariant);
    static readonly Regex EmptyBrackets = new Regex(@"\(\s*[,;]?\s*\)", RegexOptions.CultureInvariant);
    static readonly Regex Markup = new Regex(@"[`*_]", RegexOptions.CultureInvariant);
    static readonly Regex Space = new Regex(@"\s+", RegexOptions.CultureInvariant);
    // A space a removed code leaves before the punctuation that ends a word, never before a dot that starts one (.NET, .frozen).
    static readonly Regex SpaceBeforePunctuation = new Regex(@"\s+([.,)])(?=\s|$)", RegexOptions.CultureInvariant);
    static readonly Regex Allowed = new Regex(@"^[A-Za-z0-9 .,()'-]+$", RegexOptions.CultureInvariant);

    // The text of the page's help synopsis, its wrapped lines joined by one space; empty when the page has no help or no synopsis.
    public static string Synopsis(string pageText)
    {
        if (string.IsNullOrEmpty(pageText)) { return ""; }
        string[] lines = pageText.Replace("\r\n", "\n").Split('\n');
        bool inHelp = false;
        bool inSynopsis = false;
        var parts = new List<string>();
        foreach (string line in lines)
        {
            if (line.StartsWith("## ", StringComparison.Ordinal))
            {
                if (inSynopsis) { break; }
                inHelp = line.Trim() == "## help";
                continue;
            }
            if (line.StartsWith("### ", StringComparison.Ordinal))
            {
                if (inSynopsis) { break; }
                inSynopsis = inHelp && line.Trim() == "### synopsis";
                continue;
            }
            if (inSynopsis && line.Trim().Length > 0) { parts.Add(line.Trim()); }
        }
        return string.Join(" ", parts);
    }

    public static string Plain(string text)
    {
        if (string.IsNullOrEmpty(text)) { return ""; }
        string plain = Link.Replace(text, "$1");
        plain = Code.Replace(plain, "");
        plain = EmptyBrackets.Replace(plain, "");
        plain = Markup.Replace(plain, "");
        plain = Space.Replace(plain, " ");
        plain = SpaceBeforePunctuation.Replace(plain, "$1");
        return plain.Trim();
    }

    public static string PlainScalarFinding(string text)
    {
        if (string.IsNullOrWhiteSpace(text)) { return "is empty"; }
        if (text.IndexOf('\n') >= 0 || text.IndexOf('\r') >= 0) { return "spans more than one line"; }
        if (text != text.Trim()) { return "starts or ends with white space"; }
        if (!Allowed.IsMatch(text)) { return "holds a character other than letters, digits, spaces and . , - ( ) '"; }
        if (!char.IsLetterOrDigit(text[0])) { return "does not start with a letter or digit"; }
        return null;
    }
}
