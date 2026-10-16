/*
---
catzc:
  immutable:
    path: automation/Catzc.Base.Docs/types/AdrCodeForm.cs
    folder: types
    name: adr-code-form
    filetype: cs
    kind: type
    language: csharp
    track: automation
    module: Catzc.Base.Docs
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    page: docs/references/automation/catzc-base-docs/types/AdrCodeForm.cs.md
    test: automation/Catzc.Base.Docs/tests/types/AdrCodeForm.Tests.ps1
    cites:
      - ADR-PWSH-TYPES#1
---
*/

using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Text.RegularExpressions;

namespace Catzc.Base.Docs;

public static class AdrCodeForm
{
    const int MaxRange = 10000;

    static readonly Regex Token = new Regex(
        @"^(?<code>ADR-[A-Z]+(?:-[A-Z]+)*)(?:#(?<rules>[0-9]+|\{[^{}]*\}))?\z",
        RegexOptions.Compiled | RegexOptions.CultureInvariant);

    // Every citation one token names, ascending. Throws FormatException on a malformed token.
    public static IReadOnlyList<string> Expand(string token)
    {
        if (token == null) { throw new ArgumentNullException(nameof(token)); }
        Match match = Token.Match(token);
        if (!match.Success) { throw new FormatException("'" + token + "' is no ADR citation or group."); }
        string code = match.Groups["code"].Value;
        if (!match.Groups["rules"].Success) { return new[] { code }; }
        string spec = match.Groups["rules"].Value;

        var rules = new SortedSet<int>();
        if (spec[0] == '{')
        {
            string inner = spec.Substring(1, spec.Length - 2);
            if (inner.Length == 0) { throw new FormatException("'" + token + "' has an empty group."); }
            foreach (string item in inner.Split(','))
            {
                int dash = item.IndexOf('-');
                if (dash < 0)
                {
                    rules.Add(Number(item, token));
                    continue;
                }
                int from = Number(item.Substring(0, dash), token);
                int to = Number(item.Substring(dash + 1), token);
                if (to < from) { throw new FormatException("'" + token + "' has the reversed range '" + item + "'."); }
                if (to - from > MaxRange) { throw new FormatException("'" + token + "' has the range '" + item + "' wider than " + MaxRange + "."); }
                for (int rule = from; rule <= to; rule++) { rules.Add(rule); }
            }
        }
        else
        {
            rules.Add(Number(spec, token));
        }
        return rules.Select(rule => Cite(code, rule)).ToList();
    }

    // The union of every token's citations: ascending by code, a bare code before its rules, rules numerically.
    public static IReadOnlyList<string> ExpandAll(string[] tokens)
    {
        if (tokens == null) { throw new ArgumentNullException(nameof(tokens)); }
        var union = new HashSet<string>(StringComparer.Ordinal);
        foreach (string token in tokens)
        {
            foreach (string citation in Expand(token)) { union.Add(citation); }
        }
        var list = new List<string>(union);
        list.Sort(Compare);
        return list;
    }

    public static IReadOnlyList<string> Minimize(string[] citations, AdrCitationMap registry = null)
    {
        if (citations == null) { throw new ArgumentNullException(nameof(citations)); }
        var bare = new SortedSet<string>(StringComparer.Ordinal);
        var rulesByCode = new SortedDictionary<string, SortedSet<int>>(StringComparer.Ordinal);
        foreach (string citation in citations)
        {
            if (citation == null) { throw new ArgumentException("A citation is never null.", nameof(citations)); }
            IReadOnlyList<string> one = Expand(citation);
            int hash = citation.IndexOf('#');
            if (hash < 0)
            {
                bare.Add(citation);
                continue;
            }
            if (one.Count != 1) { throw new FormatException("'" + citation + "' is no single citation."); }
            string code = citation.Substring(0, hash);
            if (!rulesByCode.TryGetValue(code, out SortedSet<int> set))
            {
                set = new SortedSet<int>();
                rulesByCode[code] = set;
            }
            set.Add(int.Parse(citation.Substring(hash + 1), CultureInfo.InvariantCulture));
        }

        var tokens = new List<string>(bare);
        foreach (KeyValuePair<string, SortedSet<int>> entry in rulesByCode)
        {
            // No numbers means the whole ADR, so a bare code already names every rule of its own.
            if (bare.Contains(entry.Key)) { continue; }
            IReadOnlyList<int> declared = registry == null ? null : registry.RulesOf(entry.Key);
            if (declared != null && declared.Count > 0 && entry.Value.SetEquals(declared))
            {
                tokens.Add(entry.Key);
                continue;
            }
            tokens.Add(Group(entry.Key, entry.Value));
        }
        tokens.Sort(StringComparer.Ordinal);
        return tokens;
    }

    static string Group(string code, SortedSet<int> rules)
    {
        var parts = new List<string>();
        int[] numbers = rules.ToArray();
        int i = 0;
        while (i < numbers.Length)
        {
            int j = i;
            while (j + 1 < numbers.Length && numbers[j + 1] == numbers[j] + 1) { j++; }
            if (j - i >= 2)
            {
                parts.Add(numbers[i].ToString(CultureInfo.InvariantCulture) + "-" + numbers[j].ToString(CultureInfo.InvariantCulture));
            }
            else
            {
                for (int k = i; k <= j; k++) { parts.Add(numbers[k].ToString(CultureInfo.InvariantCulture)); }
            }
            i = j + 1;
        }
        return parts.Count == 1 && !parts[0].Contains("-") ? code + "#" + parts[0] : code + "#{" + string.Join(",", parts) + "}";
    }

    static int Number(string text, string token)
    {
        if (text.Length == 0 || text[0] == '0' || !text.All(c => c >= '0' && c <= '9') || !int.TryParse(text, NumberStyles.None, CultureInfo.InvariantCulture, out int value))
        {
            throw new FormatException("'" + token + "' has '" + text + "', which is no rule number (a positive integer without leading zeros).");
        }
        return value;
    }

    static string Cite(string code, int rule) => code + "#" + rule.ToString(CultureInfo.InvariantCulture);

    static int Compare(string left, string right)
    {
        int l = left.IndexOf('#');
        int r = right.IndexOf('#');
        int byCode = string.CompareOrdinal(l < 0 ? left : left.Substring(0, l), r < 0 ? right : right.Substring(0, r));
        if (byCode != 0) { return byCode; }
        if (l < 0 || r < 0) { return (l < 0 ? 0 : 1) - (r < 0 ? 0 : 1); }
        return int.Parse(left.Substring(l + 1), CultureInfo.InvariantCulture).CompareTo(int.Parse(right.Substring(r + 1), CultureInfo.InvariantCulture));
    }
}
