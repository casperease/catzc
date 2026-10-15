/*
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/types/CommentLexer.cs
    kind: csharp-type
    module: Catzc.Base.QualityGates
    relatives:
      page: docs/references/automation/catzc-base-qualitygates/types/CommentLexer.cs.md
      test: automation/Catzc.Base.QualityGates/tests/types/CommentLexer.Tests.ps1
    adrs:
      - ADR-REPO-LINK#{1,6}
---
*/

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
        if (CFamilyExtensions.Contains(extension)) { return CFamily(text, extension, wantComments: true); }
        if (HashExtensions.Contains(extension)) { return Hash(text, wantComments: true); }
        if (XmlExtensions.Contains(extension)) { return Xml(text); }
        return Array.Empty<(int, int)>();
    }

    // PowerShell string-literal spans (the literal token, quotes included); empty for any other language.
    public static IReadOnlyList<(int Start, int Length)> PowerShellStrings(string text) =>
        string.IsNullOrEmpty(text) ? Array.Empty<(int, int)>() : PowerShellSpans(text, wantComments: false);

    public static IReadOnlyList<(int Start, int Length)> Strings(string text, string extension)
    {
        if (string.IsNullOrEmpty(text)) { return Array.Empty<(int, int)>(); }
        if (PowerShellExtensions.Contains(extension)) { return PowerShellSpans(text, wantComments: false); }
        if (CFamilyExtensions.Contains(extension)) { return CFamily(text, extension, wantComments: false); }
        if (HashExtensions.Contains(extension)) { return Hash(text, wantComments: false); }
        return Array.Empty<(int, int)>();
    }

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

    static IReadOnlyList<(int, int)> CFamily(string text, string extension, bool wantComments)
    {
        bool isCSharp = string.Equals(extension, ".cs", StringComparison.OrdinalIgnoreCase);
        var spans = new List<(int, int)>();
        int i = 0;
        int n = text.Length;
        while (i < n)
        {
            char c = text[i];
            char next = i + 1 < n ? text[i + 1] : '\0';
            int start = i;

            if (c == '/' && next == '/')
            {
                int end = text.IndexOf('\n', i);
                if (end < 0) { end = n; }
                if (end > i && text[end - 1] == '\r') { end--; }
                if (wantComments) { spans.Add((i, end - i)); }
                i = end;
                continue;
            }
            if (c == '/' && next == '*')
            {
                int end = text.IndexOf("*/", i + 2, StringComparison.Ordinal);
                end = end < 0 ? n : end + 2;
                if (wantComments) { spans.Add((i, end - i)); }
                i = end;
                continue;
            }

            if (isCSharp && (c == '"' || c == '$') && RawQuotesAt(text, c == '$' ? SkipDollars(text, i) : i))
            {
                // Raw (optionally interpolated) string literal: a run of 3+ quotes closes with the same run length.
                int open = c == '$' ? SkipDollars(text, i) : i;
                int run = 0;
                while (open + run < n && text[open + run] == '"') { run++; }
                string closer = new string('"', run);
                int end = text.IndexOf(closer, open + run, StringComparison.Ordinal);
                i = end < 0 ? n : end + run;
                if (!wantComments) { spans.Add((start, i - start)); }
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
                if (!wantComments) { spans.Add((start, i - start)); }
                continue;
            }
            if (isCSharp && c == '$' && next == '"')
            {
                // Interpolated string: the literal starts at its '$'; its body is scanned as a regular string.
                i++;
                c = '"';
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
                    if (!wantComments) { spans.Add((start, i - start)); }
                    continue;
                }
                i = Math.Min(n, j + 1);
                if (!wantComments) { spans.Add((start, i - start)); }
                continue;
            }
            i++;
        }
        return spans;
    }

    // The index after a run of '$' (an interpolated raw string's prefix).
    static int SkipDollars(string text, int index)
    {
        while (index < text.Length && text[index] == '$') { index++; }
        return index;
    }

    // True when three quotes start at the index: a raw string literal's opening.
    static bool RawQuotesAt(string text, int index) =>
        index + 2 < text.Length && text[index] == '"' && text[index + 1] == '"' && text[index + 2] == '"';

    // A YAML file's comment spans (wantComments) or, per line, the non-blank text before its comment (otherwise).
    static IReadOnlyList<(int, int)> Hash(string text, bool wantComments)
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
                    if (!wantComments && !blank) { spans.Add((lineStart + indent, line.Length - indent)); }
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

            string code = commentAt >= 0 ? line.Substring(0, commentAt) : line;
            if (wantComments && commentAt >= 0)
            {
                spans.Add((lineStart + commentAt, line.Length - commentAt));
            }
            int codeLength = code.TrimEnd().Length;
            if (!wantComments && codeLength > indent)
            {
                spans.Add((lineStart + indent, codeLength - indent));
            }
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
