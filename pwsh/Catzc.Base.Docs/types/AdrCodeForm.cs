/*
---
catzc:
  immutable:
    with_body_sha: "82307baa9e37"
  edges:
    test: pwsh/Catzc.Base.Docs/tests/types/AdrCodeForm.Tests.ps1
    docs: "[AdrCodeForm.cs.md](docs/references/pwsh/catzc-base-docs/types/AdrCodeForm.cs.md)"
    cites:
      - ADR-PWSH-TYPES-HOSTGUARANTEEDASSEMBLIES
      - ADR-REPO-ADRCODE
---
*/

using System;
using System.Collections.Generic;
using System.Text.RegularExpressions;

namespace Catzc.Base.Docs;

// Rests on [ADR-PWSH-TYPES-HOSTGUARANTEEDASSEMBLIES](/docs/adr/automation/pwsh/hosting-csharp-types.md#rule-adr-pwsh-types-hostguaranteedassemblies).
public sealed class AdrCodeForm
{
    const string Segment = "-[A-Z][A-Z0-9]*";

    // The shape of any kind, for a config read without the registry; the registry gates check that each code is registered.
    public const string AnyKindShape = "[A-Z]{2,4}";

    // The grammar for a reader without the registry: any kind's shape, and a rule's code at its shortest, two segments after the kind.
    public static AdrCodeForm AnyKind { get; } = new AdrCodeForm("(?:" + AnyKindShape + ")", AnyKindShape + "(?:" + Segment + "){2,}");

    // The kinds as one regex group, e.g. (?:ADR|TDR).
    public string Kind { get; }

    // A code, the bare kind included.
    public string Code { get; }

    // A code with one or more segments, as a citation in text is.
    public string Cited { get; }

    // A rule's code.
    public string Rule { get; }

    readonly Regex code;
    readonly Regex rule;

    // ruleSegments: each kind, in order, to the segments a rule's code has at least after it (AdrsConfig derives them from the registry).
    public AdrCodeForm(System.Collections.IDictionary ruleSegments) : this(KindGroup(Kinds(ruleSegments)), RuleGroup(ruleSegments)) { }

    AdrCodeForm(string kind, string ruleCode)
    {
        Kind = kind;
        Code = Kind + "(?:" + Segment + ")*";
        Cited = Kind + "(?:" + Segment + ")+";
        Rule = "(?:" + ruleCode + ")";
        code = new Regex("^" + Code + "\\z", RegexOptions.CultureInvariant);
        rule = new Regex("^" + Rule + "\\z", RegexOptions.CultureInvariant);
    }

    static List<string> Checked(IEnumerable<string> kinds)
    {
        if (kinds == null) { throw new ArgumentNullException(nameof(kinds)); }
        var all = new List<string>(kinds);
        if (all.Count == 0 || all.Exists(k => k == null || !Regex.IsMatch(k, "^" + AnyKindShape + "\\z")))
        {
            throw new ArgumentException("kinds must be one or more record kinds of 2-4 upper-case letters", nameof(kinds));
        }
        return all;
    }

    static List<string> Kinds(System.Collections.IDictionary ruleSegments)
    {
        if (ruleSegments == null) { throw new ArgumentNullException(nameof(ruleSegments)); }
        var kinds = new List<string>();
        foreach (object key in ruleSegments.Keys) { kinds.Add(key as string); }
        return kinds;
    }

    static string KindGroup(IEnumerable<string> kinds) => "(?:" + string.Join("|", Checked(kinds)) + ")";

    // One alternative per segment count, its kinds in the given order.
    static string RuleGroup(System.Collections.IDictionary ruleSegments)
    {
        var kindsBySegments = new SortedDictionary<int, List<string>>();
        foreach (string kind in Checked(Kinds(ruleSegments)))
        {
            int segments = Convert.ToInt32(ruleSegments[kind], System.Globalization.CultureInfo.InvariantCulture);
            if (segments < 1) { throw new ArgumentException("kind '" + kind + "': a rule's code has one or more segments", nameof(ruleSegments)); }
            if (!kindsBySegments.TryGetValue(segments, out List<string> kinds)) { kindsBySegments[segments] = kinds = new List<string>(); }
            kinds.Add(kind);
        }
        var rules = new List<string>();
        foreach (KeyValuePair<int, List<string>> entry in kindsBySegments)
        {
            rules.Add("(?:" + string.Join("|", entry.Value) + ")(?:" + Segment + "){" + entry.Key + ",}");
        }
        return string.Join("|", rules);
    }

    // True when the text is one code of a registered kind.
    public bool IsCode(string text) => text != null && code.IsMatch(text);

    // True when the text is a rule's code of a registered kind.
    public bool IsRule(string text) => text != null && rule.IsMatch(text);

    // True when the prefix selects the code: equal to it, or a whole-segment prefix of it.
    public static bool Covers(string prefix, string code)
    {
        if (prefix == null || code == null) { return false; }
        if (string.Equals(prefix, code, StringComparison.Ordinal)) { return true; }
        return code.Length > prefix.Length && code[prefix.Length] == '-' && code.StartsWith(prefix, StringComparison.Ordinal);
    }

    // A derived list at its shortest: covered codes go, and every rule of one ADR becomes that ADR's code.
    public IReadOnlyList<string> Minimize(string[] codes, AdrCitationMap registry = null)
    {
        if (codes == null) { throw new ArgumentNullException(nameof(codes)); }
        var set = new HashSet<string>(StringComparer.Ordinal);
        foreach (string item in codes)
        {
            if (!IsCode(item)) { throw new FormatException("'" + item + "' is no code of a registered kind."); }
            set.Add(item);
        }

        if (registry != null)
        {
            var byAdr = new Dictionary<string, int>(StringComparer.Ordinal);
            foreach (string item in set)
            {
                string adr = registry.AdrOf(item);
                if (adr != null) { byAdr[adr] = byAdr.TryGetValue(adr, out int count) ? count + 1 : 1; }
            }
            foreach (KeyValuePair<string, int> entry in byAdr)
            {
                if (entry.Value == registry.RulesOf(entry.Key).Count) { set.Add(entry.Key); }
            }
        }

        var kept = new List<string>();
        foreach (string item in set)
        {
            bool covered = false;
            foreach (string other in set)
            {
                if (!string.Equals(other, item, StringComparison.Ordinal) && Covers(other, item)) { covered = true; break; }
            }
            if (!covered) { kept.Add(item); }
        }

        if (registry == null)
        {
            kept.Sort(StringComparer.Ordinal);
            return kept;
        }
        kept.Sort((left, right) =>
        {
            int byKey = string.CompareOrdinal(registry.OrderKey(left), registry.OrderKey(right));
            return byKey != 0 ? byKey : string.CompareOrdinal(left, right);
        });
        return kept;
    }
}
