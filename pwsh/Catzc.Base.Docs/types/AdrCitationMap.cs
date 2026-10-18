using System;
using System.Collections;
using System.Collections.Generic;
using System.Globalization;
using System.IO;

namespace Catzc.Base.Docs;

public sealed class AdrCitationMap
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    readonly Dictionary<string, string> pathByCode = new Dictionary<string, string>(StringComparer.Ordinal);
    readonly Dictionary<string, HashSet<int>> rulesByCode = new Dictionary<string, HashSet<int>>(StringComparer.Ordinal);
    readonly Dictionary<string, string> codeByPath = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase);
    readonly Dictionary<string, string> pathBySlug = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase);
    readonly HashSet<string> ambiguousSlugs = new HashSet<string>(StringComparer.OrdinalIgnoreCase);
    readonly HashSet<string> domainCodes = new HashSet<string>(StringComparer.Ordinal);
    readonly HashSet<string> allDocuments = new HashSet<string>(StringComparer.OrdinalIgnoreCase);
    // The named rules: each is a citation code of its own, at its ADR's path, linked to its heading's anchor.
    readonly HashSet<string> namedRules = new HashSet<string>(StringComparer.Ordinal);

    // Every registered citation code, ordinally sorted.
    public IReadOnlyList<string> Codes { get; }

    public AdrCitationMap(IDictionary entries, IEnumerable documents)
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

            var rules = new HashSet<int>();
            if (value.Contains("rules") && value["rules"] is IEnumerable ruleList && !(value["rules"] is string))
            {
                foreach (object rule in ruleList)
                {
                    rules.Add(Convert.ToInt32(rule, CultureInfo.InvariantCulture));
                }
            }
            rulesByCode[code] = rules;

            if (value.Contains("named") && value["named"] is IEnumerable nameList && !(value["named"] is string))
            {
                foreach (object named in nameList)
                {
                    string name = Convert.ToString(named, CultureInfo.InvariantCulture);
                    namedRules.Add(name);
                    pathByCode[name] = path;
                    rulesByCode[name] = new HashSet<int>();
                }
            }

            int dash = code.IndexOf('-', 4);
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

    public bool HasCode(string code) => code != null && pathByCode.ContainsKey(code);

    // True when the code names one rule by its name rather than a whole ADR.
    public bool IsNamedRule(string code) => code != null && namedRules.Contains(code);

    // The rule numbers the code's ADR declares, ascending; empty for an unknown code.
    public IReadOnlyList<int> RulesOf(string code)
    {
        if (code == null || !rulesByCode.TryGetValue(code, out HashSet<int> rules)) { return new int[0]; }
        var sorted = new List<int>(rules);
        sorted.Sort();
        return sorted;
    }

    // A domain code (ADR-AUTO) — a prefix of registered codes, not an ADR of its own.
    public bool IsDomainCode(string code) => code != null && domainCodes.Contains(code);

    public bool HasRule(string code, int rule) => code != null && rulesByCode.TryGetValue(code, out HashSet<int> rules) && rules.Contains(rule);

    // The repository-relative path of the code's ADR; null for an unknown code.
    public string PathOf(string code) => code != null && pathByCode.TryGetValue(code, out string path) ? path : null;

    // The code of the ADR at a repository-relative path; null when the path is not a registered ADR.
    public string CodeOf(string path) => path != null && codeByPath.TryGetValue(Normalize(path), out string code) ? code : null;

    // True when the repository-relative path names an existing ADR-folder document (registered or code-less).
    public bool IsDocument(string path) => path != null && allDocuments.Contains(Normalize(path));

    // The one document whose file name (without .md) is the slug; null when no document or several share it.
    public string PathOfSlug(string slug)
    {
        if (slug == null || ambiguousSlugs.Contains(slug)) { return null; }
        return pathBySlug.TryGetValue(slug, out string path) ? path : null;
    }

    public bool IsAmbiguousSlug(string slug) => slug != null && ambiguousSlugs.Contains(slug);

    // The code-link destination for a citation: '/' + the ADR path, plus '#rule-<code><n>' for a rule.
    public string Destination(string code, int? rule)
    {
        string path = PathOf(code);
        if (path == null) { return null; }
        if (namedRules.Contains(code)) { return "/" + path + "#rule-" + code.ToLowerInvariant(); }
        return rule.HasValue
            ? "/" + path + "#rule-" + code.ToLowerInvariant() + rule.Value.ToString(CultureInfo.InvariantCulture)
            : "/" + path;
    }

    static string Normalize(string path) => (path ?? string.Empty).Replace('\\', '/').TrimStart('/');
}
