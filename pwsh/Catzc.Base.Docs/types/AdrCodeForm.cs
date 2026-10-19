using System;
using System.Collections.Generic;
using System.Text.RegularExpressions;

namespace Catzc.Base.Docs;

// Rests on [ADR-PWSH-TYPES-HOSTGUARANTEEDASSEMBLIES](/docs/adr/automation/pwsh/hosting-csharp-types.md#rule-adr-pwsh-types-hostguaranteedassemblies).
public static class AdrCodeForm
{
    static readonly Regex Code = new Regex(@"^ADR(?:-[A-Z][A-Z0-9]*)*\z", RegexOptions.Compiled | RegexOptions.CultureInvariant);

    // True when the text is one ADR code: 'ADR' and upper-case segments joined by '-'.
    public static bool IsCode(string text) => text != null && Code.IsMatch(text);

    // True when the prefix selects the code: equal to it, or a whole-segment prefix of it.
    public static bool Covers(string prefix, string code)
    {
        if (prefix == null || code == null) { return false; }
        if (string.Equals(prefix, code, StringComparison.Ordinal)) { return true; }
        return code.Length > prefix.Length && code[prefix.Length] == '-' && code.StartsWith(prefix, StringComparison.Ordinal);
    }

    // A derived list at its shortest: covered codes go, and every rule of one ADR becomes that ADR's code.
    public static IReadOnlyList<string> Minimize(string[] codes, AdrCitationMap registry = null)
    {
        if (codes == null) { throw new ArgumentNullException(nameof(codes)); }
        var set = new HashSet<string>(StringComparer.Ordinal);
        foreach (string code in codes)
        {
            if (!IsCode(code)) { throw new FormatException("'" + code + "' is no ADR code."); }
            set.Add(code);
        }

        if (registry != null)
        {
            var byAdr = new Dictionary<string, int>(StringComparer.Ordinal);
            foreach (string code in set)
            {
                string adr = registry.AdrOf(code);
                if (adr != null) { byAdr[adr] = byAdr.TryGetValue(adr, out int count) ? count + 1 : 1; }
            }
            foreach (KeyValuePair<string, int> entry in byAdr)
            {
                if (entry.Value == registry.RulesOf(entry.Key).Count) { set.Add(entry.Key); }
            }
        }

        var kept = new List<string>();
        foreach (string code in set)
        {
            bool covered = false;
            foreach (string other in set)
            {
                if (!string.Equals(other, code, StringComparison.Ordinal) && Covers(other, code)) { covered = true; break; }
            }
            if (!covered) { kept.Add(code); }
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
