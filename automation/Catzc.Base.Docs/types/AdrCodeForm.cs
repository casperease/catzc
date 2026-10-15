/*
---
catzc:
  derived:
    path: automation/Catzc.Base.Docs/types/AdrCodeForm.cs
    kind: csharp-type
    module: Catzc.Base.Docs
    relatives:
      test: automation/Catzc.Base.Docs/tests/types/AdrCodeForm.Tests.ps1
    adrs:
      - ADR-PWSH-TYPES#1
---
*/

using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;

namespace Catzc.Base.Docs;

// The minimal form of a set of ADR citations, and the parser that reads it back.
//
//   ADR-X-Y#5                one rule
//   ADR-X-Y#{1,3-5,9}        a group: numbers and ranges (a range is a run of three or more)
//   ADR-X-Y#*                every rule the registry declares for the code
//   ADR-X-*                  every rule of every code under the prefix (at least two codes)
//   ADR-X-Y                  a bare code: a domain citation, never grouped or globbed
//
// Groups and ranges need no registry; a glob is relative to one, so Minimize without a registry never globs and Expand of a glob needs one.
public static class AdrCodeForm
{
    // The grouped and glob spellings after a code, for a scanner that already matches the code itself.
    public const string SuffixPattern = @"(?:-\*|#(?:\*|\d+|\{[0-9,\-]*\}))";

    const int MaxRange = 10000;

    static readonly Regex Token = new Regex(
        @"^(?<code>ADR-[A-Z]+(?:-[A-Z]+)*?)(?:(?<glob>-\*)|#(?<rules>\*|[0-9]+|\{[^{}]*\}))?\z",
        RegexOptions.Compiled | RegexOptions.CultureInvariant);

    // Every citation one token names, ascending. Throws FormatException on a malformed token.
    public static IReadOnlyList<string> Expand(string token, AdrCitationMap registry = null)
    {
        if (token == null) { throw new ArgumentNullException(nameof(token)); }
        Match match = Token.Match(token);
        if (!match.Success) { throw new FormatException("'" + token + "' is no ADR citation, group, or glob."); }
        string code = match.Groups["code"].Value;

        if (match.Groups["glob"].Success)
        {
            RequireRegistry(token, registry);
            string prefix = code + "-";
            var found = new SortedSet<string>(StringComparer.Ordinal);
            foreach (string registered in registry.Codes)
            {
                if (!registered.StartsWith(prefix, StringComparison.Ordinal)) { continue; }
                foreach (int rule in registry.RulesOf(registered)) { found.Add(Cite(registered, rule)); }
            }
            if (found.Count == 0) { throw new FormatException("'" + token + "' matches no registered rule."); }
            return Sorted(found);
        }

        if (!match.Groups["rules"].Success) { return new[] { code }; }
        string spec = match.Groups["rules"].Value;

        if (spec == "*")
        {
            RequireRegistry(token, registry);
            IReadOnlyList<int> all = registry.RulesOf(code);
            if (all.Count == 0) { throw new FormatException("'" + token + "' matches no registered rule."); }
            return all.Select(rule => Cite(code, rule)).ToList();
        }

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
    public static IReadOnlyList<string> ExpandAll(string[] tokens, AdrCitationMap registry = null)
    {
        if (tokens == null) { throw new ArgumentNullException(nameof(tokens)); }
        var union = new HashSet<string>(StringComparer.Ordinal);
        foreach (string token in tokens)
        {
            foreach (string citation in Expand(token, registry)) { union.Add(citation); }
        }
        return Sorted(union);
    }

    // The fewest tokens that name exactly the citations given. Each input is a bare code or a single rule; duplicates collapse.
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
            if (hash < 0 || one.Count != 1)
            {
                if (hash >= 0 || citation.Contains("*")) { throw new FormatException("'" + citation + "' is no single citation."); }
                bare.Add(citation);
                continue;
            }
            string code = citation.Substring(0, hash);
            if (!rulesByCode.TryGetValue(code, out SortedSet<int> set))
            {
                set = new SortedSet<int>();
                rulesByCode[code] = set;
            }
            set.Add(int.Parse(citation.Substring(hash + 1), CultureInfo.InvariantCulture));
        }

        var tokens = new List<string>(bare);
        var covered = new HashSet<string>(StringComparer.Ordinal);
        if (registry != null)
        {
            foreach (string prefix in PrefixGlobs(rulesByCode, registry, covered)) { tokens.Add(prefix + "-*"); }
        }
        foreach (KeyValuePair<string, SortedSet<int>> entry in rulesByCode)
        {
            if (covered.Contains(entry.Key)) { continue; }
            bool wholeAdr = registry != null && registry.RulesOf(entry.Key).Count >= 2 && entry.Value.SetEquals(registry.RulesOf(entry.Key));
            tokens.Add(wholeAdr ? entry.Key + "#*" : Group(entry.Key, entry.Value));
        }
        tokens.Sort(StringComparer.Ordinal);
        return tokens;
    }

    // The shortest prefixes whose every registered rule, over at least two codes, is in the set; the codes they cover are recorded.
    static List<string> PrefixGlobs(SortedDictionary<string, SortedSet<int>> rulesByCode, AdrCitationMap registry, HashSet<string> covered)
    {
        var globs = new List<string>();
        foreach (string code in rulesByCode.Keys)
        {
            if (covered.Contains(code)) { continue; }
            string[] segments = code.Split('-');
            for (int length = 2; length < segments.Length; length++)
            {
                string prefix = string.Join("-", segments, 0, length);
                var under = registry.Codes.Where(c => c.StartsWith(prefix + "-", StringComparison.Ordinal) && registry.RulesOf(c).Count > 0).ToList();
                bool whole = under.Count >= 2 && under.All(c => rulesByCode.TryGetValue(c, out SortedSet<int> have) && have.SetEquals(registry.RulesOf(c)));
                if (!whole) { continue; }
                globs.Add(prefix);
                foreach (string c in under) { covered.Add(c); }
                break;
            }
        }
        return globs;
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

    static void RequireRegistry(string token, AdrCitationMap registry)
    {
        if (registry == null) { throw new InvalidOperationException("'" + token + "' is a glob, which needs the ADR registry to expand."); }
    }

    static string Cite(string code, int rule) => code + "#" + rule.ToString(CultureInfo.InvariantCulture);

    static IReadOnlyList<string> Sorted(IEnumerable<string> citations)
    {
        var list = new List<string>(citations);
        list.Sort(Compare);
        return list;
    }

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
