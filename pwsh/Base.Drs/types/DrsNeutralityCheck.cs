/*
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-drs/types/DrsNeutralityCheck.cs.md"
  header: "generated"
---
*/

using System;
using System.Collections;
using System.Collections.Generic;
using System.Text.RegularExpressions;

using Catzc.Base.Reports;

namespace Catzc.Base.Drs;

// The engine-neutrality check: the rule summaries of the listed domains carry no engine-specific syntax.
public sealed class DrsNeutralityCheck
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    private static readonly string[] AllowedKeys = { "mode", "domains", "tokens" };
    private static readonly Regex NameRe = new Regex("^[a-z0-9]+(-[a-z0-9]+)*$", RegexOptions.Compiled);

    public CheckMode mode { get; }
    public IReadOnlyList<string> domains { get; }
    public IReadOnlyList<DrsNeutralityToken> tokens { get; }

    internal DrsNeutralityCheck(IDictionary raw, string where, List<string> errors)
    {
        mode = default(CheckMode);
        List<string> domainList = new List<string>();
        List<DrsNeutralityToken> tokenList = new List<DrsNeutralityToken>();
        domains = domainList;
        tokens = tokenList;
        if (raw == null) { return; }

        DrsChecksConfig.CheckKeys(raw, AllowedKeys, where, errors);
        mode = DrsChecksConfig.ParseMode(raw, where, errors);

        if (raw.Contains("domains") && raw["domains"] != null)
        {
            IEnumerable list = (raw["domains"] is string) ? null : raw["domains"] as IEnumerable;
            if (list == null)
            {
                errors.Add(string.Format("{0}: domains must be a list of drs.yml domain names", where));
            }
            else
            {
                foreach (object item in list)
                {
                    string domain = item == null ? null : item.ToString();
                    if (string.IsNullOrWhiteSpace(domain)) { errors.Add(string.Format("{0}: domains holds an empty name", where)); }
                    else if (domainList.Contains(domain)) { errors.Add(string.Format("{0}: domain '{1}' is listed twice", where, domain)); }
                    else { domainList.Add(domain); }
                }
            }
        }

        if (raw.Contains("tokens") && raw["tokens"] != null)
        {
            IDictionary map = raw["tokens"] as IDictionary;
            if (map == null)
            {
                errors.Add(string.Format("{0}: tokens must be a map of token name to regular expression", where));
                return;
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
        }
    }
}
