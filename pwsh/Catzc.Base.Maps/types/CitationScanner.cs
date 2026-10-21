/*
---
catzc:
  immutable:
    with_body_sha: d477575f8d4a
  edges:
    test: pwsh/Catzc.Base.Maps/tests/types/CitationScanner.Tests.ps1
    docs: "[CitationScanner.cs.md](../../../docs/references/pwsh/catzc-base-maps/types/CitationScanner.cs.md)"
    cites:
      - ADR-REPO-LINK-CODELINKS
---
*/

using System;
using System.Collections;
using System.Collections.Generic;
using System.Globalization;
using System.Text.RegularExpressions;

namespace Catzc.Base.Maps;

public static class CitationScanner
{
    // The extensions whose files carry citations; the text of no other file is read.
    public static readonly IReadOnlyList<string> CitingExtensions = new[] { ".cs", ".md", ".ps1", ".yaml", ".yml" };

    // Any kind's shape: a citation counts only when the index, read from the registry, lists its code.
    private static readonly Regex Citation = new Regex(
        @"(?<![A-Za-z0-9_\-])(?<code>" + Catzc.Base.Drs.DrsCodeForm.AnyKind.Cited + @")(?![A-Za-z0-9_\-])",
        RegexOptions.CultureInvariant);

    private static readonly Regex Reference = new Regex("^" + Catzc.Base.Drs.DrsCodeForm.AnyKind.Cited + "$", RegexOptions.CultureInvariant);

    // True when the file's kind cites ADRs (its extension is one of CitingExtensions, in any case).
    public static bool Cites(string path)
    {
        string extension = Catzc.Base.Languages.LanguagesConfig.ExtensionOf(path);
        if (extension == null) { return false; }
        foreach (string citing in CitingExtensions)
        {
            if (string.Equals(citing, extension, StringComparison.Ordinal)) { return true; }
        }
        return false;
    }

    public static IReadOnlyDictionary<string, string> Index(IDictionary raw)
    {
        Dictionary<string, string> index = new Dictionary<string, string>(StringComparer.Ordinal);
        if (raw == null) { return index; }
        List<string> errors = new List<string>();
        foreach (DictionaryEntry entry in raw)
        {
            string code = Convert.ToString(entry.Key, CultureInfo.InvariantCulture);
            string domain = Convert.ToString(entry.Value, CultureInfo.InvariantCulture);
            if (!Reference.IsMatch(code ?? ""))
            {
                errors.Add(string.Format(CultureInfo.InvariantCulture, "'{0}' is not an ADR code (ADR-<CODE>)", code));
                continue;
            }
            if (string.IsNullOrEmpty(domain))
            {
                errors.Add(string.Format(CultureInfo.InvariantCulture, "'{0}' names no domain", code));
                continue;
            }
            index[code] = domain;
        }
        if (errors.Count > 0)
        {
            throw new ArgumentException("adrs index: " + string.Join("; ", errors));
        }
        return index;
    }

    // The citations in a text whose code the index lists: canonical, distinct, in ordinal order.
    public static string[] Scan(string text, IReadOnlyDictionary<string, string> index)
    {
        if (string.IsNullOrEmpty(text) || index == null || index.Count == 0) { return Array.Empty<string>(); }
        SortedSet<string> found = new SortedSet<string>(StringComparer.Ordinal);
        foreach (Match match in Citation.Matches(text))
        {
            string code = match.Groups["code"].Value;
            if (CodeOf(code, index) == null) { continue; }
            found.Add(code);
        }
        string[] result = new string[found.Count];
        found.CopyTo(result);
        return result;
    }

    public static CitationSite[] Sites(string path, string text, IReadOnlyDictionary<string, string> index)
    {
        List<CitationSite> sites = new List<CitationSite>();
        if (string.IsNullOrEmpty(text) || index == null || index.Count == 0) { return sites.ToArray(); }
        string extension = Catzc.Base.Languages.LanguagesConfig.ExtensionOf(path ?? "") ?? "";
        bool prose = string.Equals(extension, ".md", StringComparison.Ordinal);
        string marker = string.Equals(extension, ".cs", StringComparison.Ordinal) ? "//" : "#";
        bool header = true;
        bool helpBlock = false;
        string[] lines = text.Replace("\r\n", "\n").Split('\n');
        for (int i = 0; i < lines.Length; i++)
        {
            string line = lines[i];
            string trimmed = line.TrimStart();
            bool opensBlock = !prose && marker == "#" && trimmed.StartsWith("<#", StringComparison.Ordinal);
            bool inBlock = helpBlock || opensBlock;
            if (opensBlock) { helpBlock = true; }
            if (helpBlock && line.Contains("#>")) { helpBlock = false; }
            bool commentLine = trimmed.StartsWith(marker, StringComparison.Ordinal);
            if (header && !inBlock && trimmed.Length > 0 && !commentLine) { header = false; }
            foreach (Match match in Citation.Matches(line))
            {
                string citation = match.Groups["code"].Value;
                if (CodeOf(citation, index) == null) { continue; }
                string kind;
                if (prose) { kind = CitationSite.KindText; }
                else if (inBlock || (header && commentLine) || (marker == "//" && trimmed.StartsWith("///", StringComparison.Ordinal)))
                {
                    kind = CitationSite.KindHelp;
                }
                else
                {
                    int comment = line.IndexOf(marker, StringComparison.Ordinal);
                    kind = comment >= 0 && comment < match.Index ? CitationSite.KindComment : CitationSite.KindText;
                }
                sites.Add(new CitationSite(path, i + 1, kind, citation));
            }
        }
        return sites.ToArray();
    }

    // The reference as a code, trimmed; null when it is no ADR code.
    public static string Canonical(string reference)
    {
        string code = (reference ?? "").Trim();
        return Reference.IsMatch(code) ? code : null;
    }

    // The ADR code of a citation: the longest whole-segment prefix the test accepts, the citation itself included.
    public static string CodeOf(string citation, Func<string, bool> isAdr)
    {
        if (citation == null || isAdr == null) { return null; }
        string code = citation;
        while (true)
        {
            if (isAdr(code)) { return code; }
            int dash = code.LastIndexOf('-');
            if (dash <= 0) { return null; }
            code = code.Substring(0, dash);
        }
    }

    public static string CodeOf(string citation, IReadOnlyDictionary<string, string> index) =>
        index == null ? null : CodeOf(citation, index.ContainsKey);

    // The domain of a citation's ADR, or null when the index lists no prefix of it.
    public static string DomainOf(string citation, IReadOnlyDictionary<string, string> index)
    {
        string code = CodeOf(citation, index);
        return code == null ? null : index[code];
    }

    // True when one code selects the other: equal, or a whole-segment prefix of it.
    public static bool Covers(string requested, string cited)
    {
        if (requested == null || cited == null) { return false; }
        return Catzc.Base.Drs.DrsCodeForm.Covers(requested, cited) || Catzc.Base.Drs.DrsCodeForm.Covers(cited, requested);
    }
}
