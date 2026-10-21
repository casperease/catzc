/*
---
catzc:
  immutable:
    with_body_sha: "0d901856f615"
  edges:
    test: pwsh/Catzc.Base.Drs/tests/types/DrsCitationMap.Tests.ps1
    docs: "[DrsCitationMap.cs.md](docs/references/pwsh/catzc-base-docs/types/DrsCitationMap.cs.md)"
    cites:
      - ADR-AUTO
      - ADR-PWSH-ERROR
      - ADR-REPO-LINK-CODELINKS
---
*/

using System;
using System.Collections;
using System.Collections.Generic;
using System.Globalization;
using System.IO;

namespace Catzc.Base.Drs;

public sealed class DrsCitationMap
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    readonly Dictionary<string, string> pathByCode = new Dictionary<string, string>(StringComparer.Ordinal);
    readonly Dictionary<string, List<string>> rulesByAdr = new Dictionary<string, List<string>>(StringComparer.Ordinal);
    readonly Dictionary<string, string> codeByPath = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase);
    readonly Dictionary<string, string> pathBySlug = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase);
    readonly HashSet<string> ambiguousSlugs = new HashSet<string>(StringComparer.OrdinalIgnoreCase);
    readonly HashSet<string> domainCodes = new HashSet<string>(StringComparer.Ordinal);
    readonly HashSet<string> allDocuments = new HashSet<string>(StringComparer.OrdinalIgnoreCase);
    // Each rule's ADR code and its place in that ADR's registry, the authored order.
    readonly Dictionary<string, (string Adr, int Order)> rulePlace = new Dictionary<string, (string, int)>(StringComparer.Ordinal);

    // Every registered code, ADR and rule alike, ordinally sorted.
    public IReadOnlyList<string> Codes { get; }

    public DrsCitationMap(IDictionary entries, IEnumerable documents)
    {
        if (entries == null) { throw new ArgumentNullException(nameof(entries)); }

        foreach (DictionaryEntry entry in entries)
        {
            string code = Convert.ToString(entry.Key, CultureInfo.InvariantCulture);
            if (!(entry.Value is IDictionary value) || !value.Contains("path"))
            {
                throw new ArgumentException(string.Format(CultureInfo.InvariantCulture, "citation '{0}': an entry needs a 'path'", code));
            }
            string path = Normalize(Convert.ToString(value["path"], CultureInfo.InvariantCulture));
            pathByCode[code] = path;
            codeByPath[path] = code;

            var rules = new List<string>();
            if (value.Contains("rules") && value["rules"] is IEnumerable ruleList && !(value["rules"] is string))
            {
                foreach (object item in ruleList)
                {
                    string rule = Convert.ToString(item, CultureInfo.InvariantCulture);
                    if (!rule.StartsWith(code + "-", StringComparison.Ordinal))
                    {
                        throw new ArgumentException(string.Format(CultureInfo.InvariantCulture, "citation '{0}': its rule '{1}' does not extend the ADR's code", code, rule));
                    }
                    rulePlace[rule] = (code, rules.Count);
                    rules.Add(rule);
                    pathByCode[rule] = path;
                }
            }
            rulesByAdr[code] = rules;

            int dash = code.IndexOf('-', code.IndexOf('-') + 1);
            while (dash > 0)
            {
                domainCodes.Add(code.Substring(0, dash));
                dash = code.IndexOf('-', dash + 1);
            }
        }

        var documentPaths = new List<string>(pathByCode.Values);
        if (documents != null)
        {
            foreach (object document in documents)
            {
                documentPaths.Add(Normalize(Convert.ToString(document, CultureInfo.InvariantCulture)));
            }
        }
        foreach (string path in documentPaths)
        {
            allDocuments.Add(path);
            string slug = Path.GetFileNameWithoutExtension(path);
            if (pathBySlug.TryGetValue(slug, out string existing))
            {
                if (!string.Equals(existing, path, StringComparison.OrdinalIgnoreCase)) { ambiguousSlugs.Add(slug); }
            }
            else
            {
                pathBySlug[slug] = path;
            }
        }

        var codes = new List<string>(pathByCode.Keys);
        codes.Sort(StringComparer.Ordinal);
        Codes = codes;
    }

    // True for a registered ADR code or rule code.
    public bool HasCode(string code) => code != null && pathByCode.ContainsKey(code);

    // True when the code names one rule rather than a whole ADR.
    public bool IsRule(string code) => code != null && rulePlace.ContainsKey(code);

    // The ADR code a rule belongs to; null for a code that is no registered rule.
    public string AdrOf(string rule) => rule != null && rulePlace.TryGetValue(rule, out (string Adr, int Order) place) ? place.Adr : null;

    // The longest registered ADR code that is a whole-segment prefix of the code; null when none is.
    public string ParentAdr(string code)
    {
        if (code == null) { return null; }
        int dash = code.LastIndexOf('-');
        while (dash > 0)
        {
            string prefix = code.Substring(0, dash);
            if (rulesByAdr.ContainsKey(prefix)) { return prefix; }
            dash = prefix.LastIndexOf('-');
        }
        return null;
    }

    // Sorts codes by ADR code, then a rule at its authored place in that ADR.
    public string OrderKey(string code)
    {
        if (code == null) { return string.Empty; }
        return rulePlace.TryGetValue(code, out (string Adr, int Order) place)
            ? place.Adr + "\t" + place.Order.ToString("D5", CultureInfo.InvariantCulture)
            : code;
    }

    // The rule codes the ADR declares, in authored order; empty for an unknown code.
    public IReadOnlyList<string> RulesOf(string code) =>
        code != null && rulesByAdr.TryGetValue(code, out List<string> rules) ? rules : (IReadOnlyList<string>)Array.Empty<string>();

    // A domain code (ADR-AUTO) — a prefix of registered codes, not an ADR of its own.
    public bool IsDomainCode(string code) => code != null && domainCodes.Contains(code);

    // The repository-relative path of the code's ADR; null for an unknown code.
    public string PathOf(string code) => code != null && pathByCode.TryGetValue(code, out string path) ? path : null;

    // The code of the ADR at a repository-relative path; null when the path is not a registered ADR.
    public string CodeOf(string path) => path != null && codeByPath.TryGetValue(Normalize(path), out string code) ? code : null;

    // The rule of the ADR whose heading anchor the fragment names ('#rule-adr-x-name'); null when none does.
    public string RuleOfAnchor(string adr, string fragment)
    {
        if (adr == null || fragment == null) { return null; }
        string anchor = fragment.TrimStart('#');
        foreach (string rule in RulesOf(adr))
        {
            if (string.Equals(Anchor(rule), anchor, StringComparison.Ordinal)) { return rule; }
        }
        return null;
    }

    // True when the repository-relative path names an existing ADR-folder document (registered or code-less).
    public bool IsDocument(string path) => path != null && allDocuments.Contains(Normalize(path));

    // The one document whose file name (without .md) is the slug; null when no document or several share it.
    public string PathOfSlug(string slug)
    {
        if (slug == null || ambiguousSlugs.Contains(slug)) { return null; }
        return pathBySlug.TryGetValue(slug, out string path) ? path : null;
    }

    public bool IsAmbiguousSlug(string slug) => slug != null && ambiguousSlugs.Contains(slug);

    // The code-link destination: '/' + the ADR path, plus the rule heading's anchor for a rule.
    public string Destination(string code)
    {
        string path = PathOf(code);
        if (path == null) { return null; }
        return IsRule(code) ? "/" + path + "#" + Anchor(code) : "/" + path;
    }

    // A rule heading's anchor: 'rule-' and the code in lower case.
    public static string Anchor(string rule) => "rule-" + rule.ToLowerInvariant();

    static string Normalize(string path) => (path ?? string.Empty).Replace('\\', '/').TrimStart('/');
}
