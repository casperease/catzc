// Finds the comment spans of a source file — the only places a code link lives (ADR-REPO-LINK#1) — per language
// family, by file extension:
//   PowerShell (.ps1 .psm1 .psd1)   the real PowerShell tokenizer's Comment tokens (line comments and <# #> blocks)
//   C family   (.cs .bicep)         // and /* */ (/// included), skipping string, verbatim, raw, and char literals
//   Hash       (.yml .yaml)         # at line start or after whitespace, outside quoted scalars and block scalars
//   XML        (.csproj .props .targets)  <!-- -->
// It also returns PowerShell string-literal spans, which hold docs paths as data (ADR-REPO-LINK#6). Spans are
// (Start, Length) offsets into the text, in document order.

using System;
using System.Collections.Generic;
using System.IO;
using System.Management.Automation.Language;
using System.Text.RegularExpressions;

namespace Catzc.Base.QualityGates;

public static class CommentLexer
{
    static readonly HashSet<string> PowerShellExtensions = new HashSet<string>(StringComparer.OrdinalIgnoreCase) { ".ps1", ".psm1", ".psd1" };
    static readonly HashSet<string> CFamilyExtensions = new HashSet<string>(StringComparer.OrdinalIgnoreCase) { ".cs", ".bicep" };
    static readonly HashSet<string> HashExtensions = new HashSet<string>(StringComparer.OrdinalIgnoreCase) { ".yml", ".yaml" };
    static readonly HashSet<string> XmlExtensions = new HashSet<string>(StringComparer.OrdinalIgnoreCase) { ".csproj", ".props", ".targets" };
    static readonly Regex BlockScalarHeader = new Regex(@"(?:^|[:\s-])\s*[|>][0-9+-]*\s*(?:#.*)?$", RegexOptions.Compiled);

    // True when the extension names a file whose comments carry code links.
    public static bool IsCodeExtension(string extension) =>
        PowerShellExtensions.Contains(extension) || CFamilyExtensions.Contains(extension) || HashExtensions.Contains(extension) || XmlExtensions.Contains(extension);

    public static bool IsPowerShell(string extension) => PowerShellExtensions.Contains(extension);

    public static IReadOnlyList<(int Start, int Length)> Comments(string text, string extension)
    {
        if (string.IsNullOrEmpty(text)) { return Array.Empty<(int, int)>(); }
        if (PowerShellExtensions.Contains(extension)) { return PowerShellSpans(text, wantComments: true); }
        if (CFamilyExtensions.Contains(extension)) { return CFamily(text, extension); }
        if (HashExtensions.Contains(extension)) { return Hash(text); }
        if (XmlExtensions.Contains(extension)) { return Xml(text); }
        return Array.Empty<(int, int)>();
    }

    // PowerShell string-literal spans (the literal token, quotes included); empty for any other language.
    public static IReadOnlyList<(int Start, int Length)> PowerShellStrings(string text) =>
        string.IsNullOrEmpty(text) ? Array.Empty<(int, int)>() : PowerShellSpans(text, wantComments: false);

    static IReadOnlyList<(int, int)> PowerShellSpans(string text, bool wantComments)
    {
        Parser.ParseInput(text, out Token[] tokens, out _);
        var spans = new List<(int, int)>();
        foreach (Token token in tokens)
        {
            bool isComment = token.Kind == TokenKind.Comment;
            bool isString = token is StringToken;
            if ((wantComments && isComment) || (!wantComments && isString))
            {
                spans.Add((token.Extent.StartOffset, token.Extent.EndOffset - token.Extent.StartOffset));
            }
        }
        return spans;
    }

    static IReadOnlyList<(int, int)> CFamily(string text, string extension)
    {
        bool isCSharp = string.Equals(extension, ".cs", StringComparison.OrdinalIgnoreCase);
        var spans = new List<(int, int)>();
        int i = 0;
        int n = text.Length;
        while (i < n)
        {
            char c = text[i];
            char next = i + 1 < n ? text[i + 1] : '\0';

            if (c == '/' && next == '/')
            {
                int end = text.IndexOf('\n', i);
                if (end < 0) { end = n; }
                if (end > i && text[end - 1] == '\r') { end--; }
                spans.Add((i, end - i));
                i = end;
                continue;
            }
            if (c == '/' && next == '*')
            {
                int end = text.IndexOf("*/", i + 2, StringComparison.Ordinal);
                end = end < 0 ? n : end + 2;
                spans.Add((i, end - i));
                i = end;
                continue;
            }

            if (isCSharp && c == '"' && i + 2 < n && text[i + 1] == '"' && text[i + 2] == '"')
            {
                // Raw string literal: a run of 3+ quotes closes with the same run length.
                int run = 0;
                while (i + run < n && text[i + run] == '"') { run++; }
                string closer = new string('"', run);
                int end = text.IndexOf(closer, i + run, StringComparison.Ordinal);
                i = end < 0 ? n : end + run;
                continue;
            }
            if (isCSharp && (c == '@' && next == '"' || c == '$' && next == '@' || c == '@' && next == '$'))
            {
                // Verbatim (optionally interpolated) string: "" escapes a quote.
                int j = text.IndexOf('"', i) + 1;
                while (j < n)
                {
                    if (text[j] == '"')
                    {
                        if (j + 1 < n && text[j + 1] == '"') { j += 2; continue; }
                        break;
                    }
                    j++;
                }
                i = Math.Min(n, j + 1);
                continue;
            }
            if (c == '"' || c == '\'')
            {
                // Regular string or char literal (and Bicep's '…' strings): backslash escapes, ends at the quote or line end.
                char quote = c;
                int j = i + 1;
                while (j < n && text[j] != quote && text[j] != '\n')
                {
                    if (text[j] == '\\') { j++; }
                    j++;
                }
                if (!isCSharp && quote == '\'' && j + 2 < n && text[i + 1] == '\'' && text[i + 2] == '\'')
                {
                    // Bicep multi-line string '''…'''.
                    int end = text.IndexOf("'''", i + 3, StringComparison.Ordinal);
                    i = end < 0 ? n : end + 3;
                    continue;
                }
                i = Math.Min(n, j + 1);
                continue;
            }
            i++;
        }
        return spans;
    }

    static IReadOnlyList<(int, int)> Hash(string text)
    {
        var spans = new List<(int, int)>();
        int lineStart = 0;
        int blockIndent = -1;   // >= 0 while inside a block scalar opened by a line with this indent
        while (lineStart < text.Length)
        {
            int lineEnd = text.IndexOf('\n', lineStart);
            if (lineEnd < 0) { lineEnd = text.Length; }
            int contentEnd = lineEnd > lineStart && text[lineEnd - 1] == '\r' ? lineEnd - 1 : lineEnd;
            string line = text.Substring(lineStart, contentEnd - lineStart);
            int indent = 0;
            while (indent < line.Length && line[indent] == ' ') { indent++; }
            bool blank = indent == line.Length;

            if (blockIndent >= 0)
            {
                if (blank || indent > blockIndent)
                {
                    lineStart = lineEnd + 1;
                    continue;
                }
                blockIndent = -1;
            }

            int commentAt = -1;
            char quote = '\0';
            char previous = ' ';
            for (int k = 0; k < line.Length; k++)
            {
                char c = line[k];
                if (quote != '\0')
                {
                    if (quote == '"' && c == '\\') { k++; continue; }
                    if (c == quote)
                    {
                        if (quote == '\'' && k + 1 < line.Length && line[k + 1] == '\'') { k++; continue; }
                        quote = '\0';
                    }
                    previous = c;
                    continue;
                }
                if ((c == '\'' || c == '"') && IsValueStart(line, k))
                {
                    quote = c;
                    previous = c;
                    continue;
                }
                if (c == '#' && (k == 0 || previous == ' ' || previous == '\t'))
                {
                    commentAt = k;
                    break;
                }
                previous = c;
            }

            if (commentAt >= 0)
            {
                spans.Add((lineStart + commentAt, line.Length - commentAt));
            }
            string code = commentAt >= 0 ? line.Substring(0, commentAt) : line;
            if (!blank && BlockScalarHeader.IsMatch(code.TrimEnd()))
            {
                blockIndent = indent;
            }
            lineStart = lineEnd + 1;
        }
        return spans;
    }

    // A YAML quote opens a quoted scalar only where a value can start: line start, or after ':', '-', '[', '{', ','.
    static bool IsValueStart(string line, int index)
    {
        for (int k = index - 1; k >= 0; k--)
        {
            char c = line[k];
            if (c == ' ' || c == '\t') { continue; }
            return c == ':' || c == '-' || c == '[' || c == '{' || c == ',';
        }
        return true;
    }

    static IReadOnlyList<(int, int)> Xml(string text)
    {
        var spans = new List<(int, int)>();
        int i = 0;
        while ((i = text.IndexOf("<!--", i, StringComparison.Ordinal)) >= 0)
        {
            int end = text.IndexOf("-->", i + 4, StringComparison.Ordinal);
            end = end < 0 ? text.Length : end + 3;
            spans.Add((i, end - i));
            i = end;
        }
        return spans;
    }

    // The comment family's line marker for a span, used to continue a wrapped line comment: '///', '//', '#',
    // or null for a block comment (<# #>, /* */, <!-- -->), whose continuation is plain indentation.
    public static string LineMarker(string comment)
    {
        if (comment.StartsWith("<#", StringComparison.Ordinal) || comment.StartsWith("/*", StringComparison.Ordinal) || comment.StartsWith("<!--", StringComparison.Ordinal))
        {
            return null;
        }
        if (comment.StartsWith("///", StringComparison.Ordinal)) { return "///"; }
        if (comment.StartsWith("//", StringComparison.Ordinal)) { return "//"; }
        if (comment.StartsWith("#", StringComparison.Ordinal)) { return "#"; }
        return null;
    }

    // The extension of a repository path, lowercased ('' when none).
    public static string ExtensionOf(string path) => (Path.GetExtension(path) ?? string.Empty).ToLowerInvariant();
}
