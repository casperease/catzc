using System;
using System.Collections;
using System.Collections.Generic;
using System.Text.RegularExpressions;

using Catzc.Base.Reports;

namespace Catzc.Base.Drs;

// The engine-neutrality check: the rule summaries of the listed domains carry none of the tokens of the sets each domain names.
public sealed class DrsNeutralityCheck
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    private static readonly string[] AllowedKeys = { "mode", "domains", "token_sets" };
    private static readonly Regex NameRe = new Regex("^[a-z0-9]+(-[a-z0-9]+)*$", RegexOptions.Compiled);

    public CheckMode mode { get; }
    // Each checked domain and the token sets it is held to, in file order.
    public IReadOnlyDictionary<string, IReadOnlyList<string>> domains { get; }
    // Each named token set and its tokens, in file order.
    public IReadOnlyDictionary<string, IReadOnlyList<DrsNeutralityToken>> token_sets { get; }

    internal DrsNeutralityCheck(IDictionary raw, string where, List<string> errors)
    {
        mode = default(CheckMode);
        Dictionary<string, IReadOnlyList<string>> domainMap = new Dictionary<string, IReadOnlyList<string>>(StringComparer.Ordinal);
        Dictionary<string, IReadOnlyList<DrsNeutralityToken>> setMap =
            new Dictionary<string, IReadOnlyList<DrsNeutralityToken>>(StringComparer.Ordinal);
        domains = domainMap;
        token_sets = setMap;
        if (raw == null) { return; }

        DrsChecksConfig.CheckKeys(raw, AllowedKeys, where, errors);
        mode = DrsChecksConfig.ParseMode(raw, where, errors);

        if (raw.Contains("token_sets") && raw["token_sets"] != null)
        {
            IDictionary sets = raw["token_sets"] as IDictionary;
            if (sets == null) { errors.Add(string.Format("{0}: token_sets must be a map of set name to a token map", where)); }
            else
            {
                foreach (DictionaryEntry entry in sets)
                {
                    string set = entry.Key == null ? string.Empty : entry.Key.ToString();
                    if (!NameRe.IsMatch(set))
                    {
                        errors.Add(string.Format("{0}: token set name '{1}' must be kebab-case", where, set));
                        continue;
                    }
                    setMap[set] = ReadTokens(entry.Value as IDictionary, string.Format("{0}: token set '{1}'", where, set), errors);
                }
            }
        }

        if (raw.Contains("domains") && raw["domains"] != null)
        {
            IDictionary map = raw["domains"] as IDictionary;
            if (map == null)
            {
                errors.Add(string.Format("{0}: domains must be a map of drs.yml domain name to its token sets", where));
                return;
            }
            foreach (DictionaryEntry entry in map)
            {
                string domain = entry.Key == null ? string.Empty : entry.Key.ToString();
                if (string.IsNullOrWhiteSpace(domain))
                {
                    errors.Add(string.Format("{0}: domains holds an empty name", where));
                    continue;
                }
                IEnumerable list = (entry.Value is string) ? null : entry.Value as IEnumerable;
                List<string> setNames = new List<string>();
                if (list != null)
                {
                    foreach (object item in list)
                    {
                        string set = item == null ? null : item.ToString();
                        if (string.IsNullOrWhiteSpace(set)) { continue; }
                        if (!setMap.ContainsKey(set))
                        {
                            errors.Add(string.Format("{0}: domain '{1}' names token set '{2}', which token_sets does not declare", where, domain, set));
                        }
                        else if (setNames.Contains(set))
                        {
                            errors.Add(string.Format("{0}: domain '{1}' names token set '{2}' twice", where, domain, set));
                        }
                        else { setNames.Add(set); }
                    }
                }
                if (list == null)
                {
                    errors.Add(string.Format("{0}: domain '{1}' must list the token sets it is held to", where, domain));
                }
                domainMap[domain] = setNames;
            }
        }
    }

    // The tokens a domain is held to: every token of its sets, in set order then file order.
    public IReadOnlyList<DrsNeutralityToken> TokensFor(string domain)
    {
        List<DrsNeutralityToken> tokens = new List<DrsNeutralityToken>();
        if (domain == null || !domains.TryGetValue(domain, out IReadOnlyList<string> sets)) { return tokens; }
        foreach (string set in sets)
        {
            tokens.AddRange(token_sets[set]);
        }
        return tokens;
    }

    private static List<DrsNeutralityToken> ReadTokens(IDictionary map, string where, List<string> errors)
    {
        List<DrsNeutralityToken> tokenList = new List<DrsNeutralityToken>();
        if (map == null)
        {
            errors.Add(string.Format("{0}: must be a map of token name to regular expression", where));
            return tokenList;
        }
        foreach (DictionaryEntry entry in map)
        {
            string name = entry.Key == null ? string.Empty : entry.Key.ToString();
            string pattern = entry.Value == null ? null : entry.Value.ToString();
            if (!NameRe.IsMatch(name))
            {
                errors.Add(string.Format("{0}: token name '{1}' must be kebab-case", where, name));
                continue;
            }
            if (string.IsNullOrEmpty(pattern))
            {
                errors.Add(string.Format("{0}: token '{1}' needs a pattern", where, name));
                continue;
            }
            Regex compiled;
            try
            {
                compiled = new Regex(pattern, RegexOptions.CultureInvariant);
            }
            catch (ArgumentException e)
            {
                errors.Add(string.Format("{0}: token '{1}' pattern does not compile: {2}", where, name, e.Message));
                continue;
            }
            tokenList.Add(new DrsNeutralityToken(name, pattern, compiled));
        }
        return tokenList;
    }
}
