/*
---
catzc:
  derived:
    path: automation/Catzc.Base.Maps/types/CitationScanner.cs
    kind: type
    module: Catzc.Base.Maps
    adrs:
      - ADR-REPO-LINK#3
---
*/

// A look-alike is no citation: an unlisted code, a code glued to a letter, digit, underscore or hyphen, or lowercase text.
// [comment:1](/docs/references/automation/catzc-base-maps/types/CitationScanner.cs.md#comment1)

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

    private static readonly Regex Citation = new Regex(
        @"(?<![A-Za-z0-9_\-])(?<code>ADR(?:-[A-Z0-9]+)+)(?:[#:](?<rule>[0-9]+))?(?![A-Za-z0-9_\-])",
        RegexOptions.CultureInvariant);

    private static readonly Regex Reference = new Regex(@"^(?<code>ADR(?:-[A-Z0-9]+)+)(?:[#:](?<rule>[0-9]+))?$",
        RegexOptions.CultureInvariant);

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

    // A key that is not an ADR code, or an empty domain, throws at once, so a bad registry never reaches a scan.
    // [comment:2](/docs/references/automation/catzc-base-maps/types/CitationScanner.cs.md#comment2)
    public static IReadOnlyDictionary<string, string> Index(IDictionary raw)
    {
        Dictionary<string, string> index = new Dictionary<string, string>(StringComparer.Ordinal);
        if (raw == null) { return index; }
        List<string> errors = new List<string>();
        foreach (DictionaryEntry entry in raw)
        {
            string code = Convert.ToString(entry.Key, CultureInfo.InvariantCulture);
            string domain = Convert.ToString(entry.Value, CultureInfo.InvariantCulture);
            Match match = Reference.Match(code ?? "");
            if (!match.Success || match.Groups["rule"].Success)
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
            if (!index.ContainsKey(code)) { continue; }
            found.Add(match.Groups["rule"].Success ? code + "#" + match.Groups["rule"].Value : code);
        }
        string[] result = new string[found.Count];
        found.CopyTo(result);
        return result;
    }

    // Only the header is help; a later comment is a passing mention, so a subject citation differs from a stray one.
    // [comment:3](/docs/references/automation/catzc-base-maps/types/CitationScanner.cs.md#comment3)
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
                string code = match.Groups["code"].Value;
                if (!index.ContainsKey(code)) { continue; }
                string citation = match.Groups["rule"].Success ? code + "#" + match.Groups["rule"].Value : code;
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

    // The colon form and the hash form of one rule become one spelling, so equal rules compare equal.
    // [comment:4](/docs/references/automation/catzc-base-maps/types/CitationScanner.cs.md#comment4)
    public static string Canonical(string reference)
    {
        Match match = Reference.Match((reference ?? "").Trim());
        if (!match.Success) { return null; }
        return match.Groups["rule"].Success ? match.Groups["code"].Value + "#" + match.Groups["rule"].Value : match.Groups["code"].Value;
    }

    // The ADR code of a canonical citation: the citation without its #n.
    public static string CodeOf(string citation)
    {
        if (citation == null) { return null; }
        int hash = citation.IndexOf('#');
        return hash < 0 ? citation : citation.Substring(0, hash);
    }

    // The domain of a citation's ADR, or null when the index does not list its code.
    public static string DomainOf(string citation, IReadOnlyDictionary<string, string> index)
    {
        string code = CodeOf(citation);
        if (code == null || index == null) { return null; }
        string domain;
        return index.TryGetValue(code, out domain) ? domain : null;
    }

    // Asymmetric: a one-rule request covers a bare citation of its ADR but never another rule, so a bare request is the wider.
    // [comment:5](/docs/references/automation/catzc-base-maps/types/CitationScanner.cs.md#comment5)
    public static bool Covers(string requested, string cited)
    {
        if (requested == null || cited == null) { return false; }
        if (string.Equals(requested, cited, StringComparison.Ordinal)) { return true; }
        string requestedCode = CodeOf(requested);
        string citedCode = CodeOf(cited);
        if (!string.Equals(requestedCode, citedCode, StringComparison.Ordinal)) { return false; }
        return string.Equals(requested, requestedCode, StringComparison.Ordinal) || string.Equals(cited, citedCode, StringComparison.Ordinal);
    }
}
